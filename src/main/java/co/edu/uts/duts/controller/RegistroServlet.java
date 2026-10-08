package co.edu.uts.duts.controller;

import co.edu.uts.duts.dao.UsuarioDAO;
import co.edu.uts.duts.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/registro")
public class RegistroServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/registro.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        
        String nombre = req.getParameter("nombre_completo");
        String correo = req.getParameter("correo");
        String username = req.getParameter("username");
        String codigo = req.getParameter("codigo_estudiantil");
        String programa = req.getParameter("programa_academico");
        String semestreStr = req.getParameter("semestre");
        String clave = req.getParameter("clave");
        String confirmarClave = req.getParameter("confirmar_clave");

        // Validación estricta en el servidor
        if (nombre == null || correo == null || username == null || clave == null) {
            req.setAttribute("error", "Faltan datos obligatorios.");
            req.getRequestDispatcher("/registro.jsp").forward(req, resp);
            return;
        }

        if (!clave.equals(confirmarClave)) {
            req.setAttribute("error", "Las contraseñas no coinciden.");
            req.getRequestDispatcher("/registro.jsp").forward(req, resp);
            return;
        }
        
        if (clave.length() < 8) {
            req.setAttribute("error", "La contraseña debe tener mínimo 8 caracteres.");
            req.getRequestDispatcher("/registro.jsp").forward(req, resp);
            return;
        }

        Usuario u = new Usuario();
        u.setNombreCompleto(nombre);
        u.setCorreo(correo);
        u.setUsername(username);
        u.setCodigoEstudiantil(codigo);
        u.setProgramaAcademico(programa);
        
        try {
            u.setSemestre(Integer.parseInt(semestreStr));
        } catch(NumberFormatException e) {
            req.setAttribute("error", "El semestre debe ser un número.");
            req.getRequestDispatcher("/registro.jsp").forward(req, resp);
            return;
        }

        boolean registrado = usuarioDAO.registrarEstudiante(u, clave);
        if (registrado) {
            req.setAttribute("exito", "Registro exitoso. ¡Has recibido un bono de bienvenida de 500 DUTS! Ahora puedes iniciar sesión.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        } else {
            req.setAttribute("error", "Error al registrar. Verifica que el código, correo o usuario no estén ya registrados.");
            req.getRequestDispatcher("/registro.jsp").forward(req, resp);
        }
    }
}
