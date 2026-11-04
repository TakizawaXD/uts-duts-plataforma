package co.edu.uts.duts.controller;

import co.edu.uts.duts.dao.UsuarioDAO;
import co.edu.uts.duts.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * LoginServlet: Portal de acceso al ecosistema DUTS.
 * Valida credenciales contra BCrypt y establece la sesión institucional.
 */
@WebServlet("/login")
public class LoginServlet extends BaseServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (esUsuarioAutenticado(req)) {
            redirect(req, resp, "/dashboard");
            return;
        }
        forward(req, resp, "/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String usuario = getParamTrimmed(req, "usuario", null);
        String clave = req.getParameter("clave");

        if (usuario == null || clave == null || clave.trim().isEmpty()) {
            req.setAttribute("error", "Por favor ingresa usuario y contraseña.");
            forward(req, resp, "/login.jsp");
            return;
        }

        Usuario u = usuarioDAO.autenticar(usuario, clave);
        if (u != null) {
            HttpSession session = req.getSession(true);
            session.setAttribute("usuario", u);
            redirect(req, resp, "/dashboard");
        } else {
            req.setAttribute("error", "Credenciales incorrectas. Inténtalo de nuevo.");
            forward(req, resp, "/login.jsp");
        }
    }
}
