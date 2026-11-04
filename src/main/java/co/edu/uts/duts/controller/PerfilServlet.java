package co.edu.uts.duts.controller;

import co.edu.uts.duts.dao.CuentaDAO;
import co.edu.uts.duts.dao.UsuarioDAO;
import co.edu.uts.duts.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

/**
 * PerfilServlet: Gestión de datos de cuenta institucional, programa académico,
 * semestre y carga multipart del avatar fotográfico del estudiante.
 */
@WebServlet("/perfil")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 25    // 25MB
)
public class PerfilServlet extends BaseServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final CuentaDAO cuentaDAO = new CuentaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!asegurarAutenticacion(req, resp)) {
            return;
        }

        Usuario usuarioSesion = getUsuarioSesion(req);
        Usuario usuarioFresco = usuarioDAO.obtenerPorId(usuarioSesion.getId());
        if (usuarioFresco != null) {
            req.getSession().setAttribute("usuario", usuarioFresco);
            req.setAttribute("usuarioPerfil", usuarioFresco);
        } else {
            req.setAttribute("usuarioPerfil", usuarioSesion);
        }

        double saldo = cuentaDAO.obtenerSaldoPorUsuarioId(usuarioSesion.getId());
        req.setAttribute("saldo", saldo);

        boolean editMode = "true".equalsIgnoreCase(req.getParameter("edit"));
        req.setAttribute("editMode", editMode);

        transferirFlashMessages(req);
        forward(req, resp, "/perfil.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!asegurarAutenticacion(req, resp)) {
            return;
        }

        Usuario u = getUsuarioSesion(req);
        String action = req.getParameter("action");

        if ("actualizar_perfil".equals(action)) {
            procesarActualizarPerfil(req, u);
        } else if ("cambiar_foto".equals(action)) {
            procesarCambiarFoto(req, u);
        } else if ("restablecer_foto".equals(action)) {
            procesarRestablecerFoto(req, u);
        }

        redirect(req, resp, "/perfil");
    }

    private void procesarActualizarPerfil(HttpServletRequest req, Usuario u) {
        String nombreCompleto = getParamTrimmed(req, "nombreCompleto", null);
        String correo = getParamTrimmed(req, "correo", null);
        String programaAcademico = getParamTrimmed(req, "programaAcademico", null);
        int semestre = getParamInt(req, "semestre", u.getSemestre());

        if (nombreCompleto == null || correo == null || programaAcademico == null) {
            setFlashError(req, "Por favor completa todos los campos obligatorios.");
            return;
        }

        boolean ok = usuarioDAO.actualizarPerfil(u.getId(), nombreCompleto, correo, programaAcademico, semestre);
        if (ok) {
            setFlashSuccess(req, "Información de perfil actualizada exitosamente en el sistema.");
        } else {
            setFlashError(req, "No se pudo actualizar el perfil.");
        }
    }

    private void procesarCambiarFoto(HttpServletRequest req, Usuario u) {
        try {
            Part filePart = req.getPart("foto");
            if (filePart == null || filePart.getSize() <= 0) {
                setFlashError(req, "Por favor selecciona un archivo de imagen para subir.");
                return;
            }

            String fileName = extractFileName(filePart);
            String ext = "jpg";
            int dotIndex = fileName.lastIndexOf('.');
            if (dotIndex > 0) {
                ext = fileName.substring(dotIndex + 1).toLowerCase();
            }

            if (!ext.matches("jpe?g|png|webp|gif")) {
                setFlashError(req, "Formato de imagen no permitido. Usa archivos JPG, PNG o WEBP.");
                return;
            }

            String newFileName = "avatar_" + u.getId() + "_" + System.currentTimeMillis() + "." + ext;

            // 1. Guardar en webapp desplegada
            String deployedPath = req.getServletContext().getRealPath("/assets/images");
            File targetFile = null;
            if (deployedPath != null) {
                File uploadDir = new File(deployedPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                targetFile = new File(uploadDir, newFileName);
                try (InputStream input = filePart.getInputStream()) {
                    Files.copy(input, targetFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
            }

            // 2. Guardar en directorio de desarrollo para persistir entre builds
            try {
                String projectDir = System.getProperty("user.dir");
                File srcImagesDir = new File(projectDir, "src/main/webapp/assets/images");
                if (srcImagesDir.exists() && targetFile != null && targetFile.exists()) {
                    File srcFile = new File(srcImagesDir, newFileName);
                    Files.copy(targetFile.toPath(), srcFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
            } catch (Exception ignored) {}

            // 3. Persistir nombre en base de datos
            boolean ok = usuarioDAO.actualizarFotoPerfil(u.getId(), newFileName);
            if (ok) {
                u.setFotoPerfil(newFileName);
                req.getSession().setAttribute("usuario", u);
                setFlashSuccess(req, "Foto de perfil actualizada exitosamente.");
            } else {
                setFlashError(req, "No se pudo actualizar la foto de perfil en la base de datos.");
            }
        } catch (Exception e) {
            setFlashError(req, "Error al procesar la imagen: " + e.getMessage());
        }
    }

    private void procesarRestablecerFoto(HttpServletRequest req, Usuario u) {
        boolean ok = usuarioDAO.actualizarFotoPerfil(u.getId(), "default-avatar.svg");
        if (ok) {
            u.setFotoPerfil("default-avatar.svg");
            req.getSession().setAttribute("usuario", u);
            setFlashSuccess(req, "Foto de perfil restablecida al avatar predeterminado.");
        } else {
            setFlashError(req, "No se pudo restablecer la foto de perfil.");
        }
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp != null) {
            String[] tokens = contentDisp.split(";");
            for (String token : tokens) {
                if (token.trim().startsWith("filename")) {
                    String fn = token.substring(token.indexOf('=') + 1).trim();
                    if (fn.startsWith("\"") && fn.endsWith("\"")) {
                        fn = fn.substring(1, fn.length() - 1);
                    }
                    int idx = Math.max(fn.lastIndexOf('/'), fn.lastIndexOf('\\'));
                    if (idx >= 0) {
                        fn = fn.substring(idx + 1);
                    }
                    return fn;
                }
            }
        }
        return "default-avatar.svg";
    }
}
