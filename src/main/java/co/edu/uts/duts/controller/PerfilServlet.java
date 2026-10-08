package co.edu.uts.duts.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.InputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

import co.edu.uts.duts.dao.CuentaDAO;
import co.edu.uts.duts.dao.UsuarioDAO;
import co.edu.uts.duts.model.Usuario;

@WebServlet("/perfil")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 25    // 25MB
)
public class PerfilServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO = new UsuarioDAO();
    private CuentaDAO cuentaDAO = new CuentaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
        Usuario usuarioFresco = usuarioDAO.obtenerPorId(usuarioSesion.getId());
        if (usuarioFresco != null) {
            session.setAttribute("usuario", usuarioFresco);
            req.setAttribute("usuarioPerfil", usuarioFresco);
        } else {
            req.setAttribute("usuarioPerfil", usuarioSesion);
        }

        double saldo = cuentaDAO.obtenerSaldoPorUsuarioId(usuarioSesion.getId());
        req.setAttribute("saldo", saldo);

        boolean editMode = "true".equalsIgnoreCase(req.getParameter("edit"));
        req.setAttribute("editMode", editMode);

        if (session.getAttribute("flashSuccess") != null) {
            req.setAttribute("flashSuccess", session.getAttribute("flashSuccess"));
            session.removeAttribute("flashSuccess");
        }
        if (session.getAttribute("flashError") != null) {
            req.setAttribute("flashError", session.getAttribute("flashError"));
            session.removeAttribute("flashError");
        }

        req.getRequestDispatcher("/perfil.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Usuario u = (Usuario) session.getAttribute("usuario");
        String action = req.getParameter("action");

        if ("actualizar_perfil".equals(action)) {
            String nombreCompleto = req.getParameter("nombreCompleto");
            String correo = req.getParameter("correo");
            String programaAcademico = req.getParameter("programaAcademico");
            String semestreStr = req.getParameter("semestre");

            if (nombreCompleto == null || nombreCompleto.trim().isEmpty() ||
                correo == null || correo.trim().isEmpty() ||
                programaAcademico == null || programaAcademico.trim().isEmpty()) {
                session.setAttribute("flashError", "Por favor completa todos los campos obligatorios.");
            } else {
                try {
                    int semestre = semestreStr != null && !semestreStr.trim().isEmpty() ? Integer.parseInt(semestreStr.trim()) : u.getSemestre();
                    boolean ok = usuarioDAO.actualizarPerfil(u.getId(), nombreCompleto, correo, programaAcademico, semestre);
                    if (ok) {
                        session.setAttribute("flashSuccess", "Información de perfil actualizada exitosamente en el sistema.");
                    } else {
                        session.setAttribute("flashError", "No se pudo actualizar el perfil.");
                    }
                } catch (Exception e) {
                    session.setAttribute("flashError", "Formato de datos no válido.");
                }
            }
        } else if ("cambiar_foto".equals(action)) {
            try {
                Part filePart = req.getPart("foto");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = extractFileName(filePart);
                    String ext = "jpg";
                    int dotIndex = fileName.lastIndexOf('.');
                    if (dotIndex > 0) {
                        ext = fileName.substring(dotIndex + 1).toLowerCase();
                    }

                    if (!ext.matches("jpe?g|png|webp|gif")) {
                        session.setAttribute("flashError", "Formato de imagen no permitido. Usa archivos JPG, PNG o WEBP.");
                    } else {
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

                        // 2. Guardar en directorio fuente para persistir en rebuilds
                        try {
                            String projectDir = System.getProperty("user.dir");
                            File srcImagesDir = new File(projectDir, "src/main/webapp/assets/images");
                            if (srcImagesDir.exists() && targetFile != null && targetFile.exists()) {
                                File srcFile = new File(srcImagesDir, newFileName);
                                Files.copy(targetFile.toPath(), srcFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                            }
                        } catch (Exception ignored) {}

                        // 3. Actualizar en BD
                        boolean ok = usuarioDAO.actualizarFotoPerfil(u.getId(), newFileName);
                        if (ok) {
                            u.setFotoPerfil(newFileName);
                            session.setAttribute("usuario", u);
                            session.setAttribute("flashSuccess", "Foto de perfil actualizada exitosamente.");
                        } else {
                            session.setAttribute("flashError", "No se pudo actualizar la foto de perfil en la base de datos.");
                        }
                    }
                } else {
                    session.setAttribute("flashError", "Por favor selecciona un archivo de imagen para subir.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("flashError", "Error al procesar la imagen: " + e.getMessage());
            }
        } else if ("restablecer_foto".equals(action)) {
            boolean ok = usuarioDAO.actualizarFotoPerfil(u.getId(), "avatar.jpg");
            if (ok) {
                u.setFotoPerfil("avatar.jpg");
                session.setAttribute("usuario", u);
                session.setAttribute("flashSuccess", "Foto de perfil restablecida al avatar predeterminado.");
            } else {
                session.setAttribute("flashError", "No se pudo restablecer la foto de perfil.");
            }
        }

        resp.sendRedirect(req.getContextPath() + "/perfil");
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
        return "avatar.jpg";
    }
}

