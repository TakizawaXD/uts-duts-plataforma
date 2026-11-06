package co.edu.uts.duts.controller;

import co.edu.uts.duts.dao.UsuarioDAO;
import co.edu.uts.duts.security.LoginRateLimiter;
import co.edu.uts.duts.security.SecurityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * RecuperarClaveServlet: Servicio seguro de recuperación y restablecimiento
 * de contraseña institucional para la plataforma UTS DUTS.
 */
@WebServlet("/recuperar-clave")
public class RecuperarClaveServlet extends BaseServlet {

    private static final Logger log = LoggerFactory.getLogger(RecuperarClaveServlet.class);
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Redirigir a index si se intenta acceder por GET directo
        redirect(req, resp, "/index");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");

        String ipCliente = SecurityUtils.obtenerIpCliente(req);
        String rateLimitKey = "recuperar:" + ipCliente;

        if (LoginRateLimiter.estaBloqueado(rateLimitKey)) {
            long segRestantes = LoginRateLimiter.obtenerSegundosRestantes(rateLimitKey);
            resp.setStatus(429); // 429 Too Many Requests
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"Demasiados intentos. Por favor espera " + segRestantes + " segundos antes de volver a intentar.\"}");
            return;
        }

        String usuario = getParamTrimmed(req, "usuario", null);
        String correo = getParamTrimmed(req, "correo", null);
        String nuevaClave = req.getParameter("nuevaClave");
        String confirmarClave = req.getParameter("confirmarClave");

        if (usuario == null || correo == null || nuevaClave == null || confirmarClave == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"Por favor completa todos los campos requeridos.\"}");
            return;
        }

        if (!nuevaClave.equals(confirmarClave)) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"Las contraseñas no coinciden. Por favor verifícalas.\"}");
            return;
        }

        if (nuevaClave.length() < 8) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"La nueva contraseña debe tener como mínimo 8 caracteres.\"}");
            return;
        }

        boolean exitoso = usuarioDAO.restablecerPassword(usuario, correo, nuevaClave);

        if (exitoso) {
            LoginRateLimiter.registrarExito(rateLimitKey);
            log.info("Restablecimiento de clave exitoso para usuario/codigo '{}' desde IP {}", usuario, ipCliente);
            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write("{\"status\":\"success\",\"message\":\"¡Contraseña actualizada con éxito! Ya puedes iniciar sesión con tu nueva clave.\"}");
        } else {
            LoginRateLimiter.registrarFallo(rateLimitKey);
            log.warn("Fallo al restablecer clave: los datos no coinciden para usuario '{}' y correo '{}' desde IP {}", usuario, correo, ipCliente);
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"Los datos ingresados no coinciden con ningún usuario o correo institucional activo registrado.\"}");
        }
    }
}
