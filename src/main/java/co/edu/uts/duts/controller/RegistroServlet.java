package co.edu.uts.duts.controller;

import co.edu.uts.duts.dao.UsuarioDAO;
import co.edu.uts.duts.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * RegistroServlet: Registro inicial de nuevos estudiantes uteístas.
 * Acredita bono de bienvenida de 500 DUTS y crea cuenta transaccional.
 */
@WebServlet("/registro")
public class RegistroServlet extends BaseServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (esUsuarioAutenticado(req)) {
            redirect(req, resp, "/dashboard");
            return;
        }
        forward(req, resp, "/registro.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String nombre = getParamTrimmed(req, "nombre_completo", null);
        String correo = getParamTrimmed(req, "correo", null);
        String username = getParamTrimmed(req, "username", null);
        String codigo = getParamTrimmed(req, "codigo_estudiantil", null);
        String programa = getParamTrimmed(req, "programa_academico", null);
        int semestre = getParamInt(req, "semestre", -1);
        String clave = req.getParameter("clave");
        String confirmarClave = req.getParameter("confirmar_clave");

        // Validaciones estrictas
        if (nombre == null || correo == null || username == null || codigo == null || clave == null) {
            req.setAttribute("error", "Faltan datos obligatorios.");
            forward(req, resp, "/registro.jsp");
            return;
        }

        if (!clave.equals(confirmarClave)) {
            req.setAttribute("error", "Las contraseñas no coinciden.");
            forward(req, resp, "/registro.jsp");
            return;
        }

        if (clave.length() < 8) {
            req.setAttribute("error", "La contraseña debe tener mínimo 8 caracteres.");
            forward(req, resp, "/registro.jsp");
            return;
        }

        if (semestre < 1 || semestre > 10) {
            req.setAttribute("error", "El semestre debe estar entre 1 y 10.");
            forward(req, resp, "/registro.jsp");
            return;
        }

        Usuario u = new Usuario();
        u.setNombreCompleto(nombre);
        u.setCorreo(correo);
        u.setUsername(username);
        u.setCodigoEstudiantil(codigo);
        u.setProgramaAcademico(programa != null ? programa : "Tecnología en Sistemas");
        u.setSemestre(semestre);

        boolean registrado = usuarioDAO.registrarEstudiante(u, clave);
        if (registrado) {
            req.setAttribute("exito", "Registro exitoso. ¡Has recibido un bono de bienvenida de 500 DUTS! Ahora puedes iniciar sesión.");
            forward(req, resp, "/login.jsp");
        } else {
            req.setAttribute("error", "Error al registrar. Verifica que el código, correo o usuario no estén ya registrados.");
            forward(req, resp, "/registro.jsp");
        }
    }
}
