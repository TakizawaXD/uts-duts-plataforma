package co.edu.uts.duts.controller;

import co.edu.uts.duts.dao.UsuarioDAO;
import co.edu.uts.duts.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String usuario = req.getParameter("usuario");
        String clave = req.getParameter("clave");

        // Validación 100% en el servidor sin JavaScript
        if (usuario == null || usuario.trim().isEmpty() || clave == null || clave.trim().isEmpty()) {
            req.setAttribute("error", "Por favor ingresa usuario y contraseña.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        Usuario u = usuarioDAO.autenticar(usuario, clave);
        if (u != null) {
            HttpSession session = req.getSession();
            session.setAttribute("usuario", u);
            // Redirigir al dashboard
            resp.sendRedirect(req.getContextPath() + "/dashboard");
        } else {
            req.setAttribute("error", "Credenciales incorrectas. Inténtalo de nuevo.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
}
