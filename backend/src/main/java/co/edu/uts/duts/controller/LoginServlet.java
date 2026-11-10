package co.edu.uts.duts.controller;

import co.edu.uts.duts.dao.UsuarioDAO;
import co.edu.uts.duts.model.Usuario;
import co.edu.uts.duts.security.LoginRateLimiter;
import co.edu.uts.duts.security.SecurityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * LoginServlet: Portal de acceso al ecosistema DUTS.
 * Integra protección activa contra ataques de fuerza bruta (Rate Limiting),
 * regeneración de sesión anti-fijación y autenticación con BCrypt.
 */
@WebServlet(urlPatterns = {"/index", "/login"})
public class LoginServlet extends BaseServlet {

    private static final Logger log = LoggerFactory.getLogger(LoginServlet.class);
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (esUsuarioAutenticado(req)) {
            redirect(req, resp, "/dashboard");
            return;
        }
        if ("/login".equals(req.getServletPath())) {
            redirect(req, resp, "/index");
            return;
        }
        forward(req, resp, "/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String usuario = getParamTrimmed(req, "usuario", null);
        String clave = req.getParameter("clave");
        String ipCliente = SecurityUtils.obtenerIpCliente(req);

        // Clave única de rastreo para mitigación de fuerza bruta
        String rateLimitKey = ipCliente + ":" + (usuario != null ? usuario.toLowerCase() : "anon");

        // 1. Verificar si la IP o cuenta está actualmente bloqueada
        if (LoginRateLimiter.estaBloqueado(rateLimitKey)) {
            long segRestantes = LoginRateLimiter.obtenerSegundosRestantes(rateLimitKey);
            log.warn("ACCESO DENEGADO (BLOQUEO TEMPORAL): IP '{}' usuario '{}' ({}) segundos restantes.", 
                    ipCliente, usuario, segRestantes);
            req.setAttribute("error", "Demasiados intentos fallidos consecutivos. Tu acceso ha sido bloqueado temporalmente por seguridad institucional (" + segRestantes + " segundos restantes).");
            forward(req, resp, "/login.jsp");
            return;
        }

        // 2. Validación de campos obligatorios
        if (usuario == null || clave == null || clave.trim().isEmpty()) {
            req.setAttribute("error", "Por favor ingresa usuario y contraseña.");
            forward(req, resp, "/login.jsp");
            return;
        }

        // 3. Autenticación con BCrypt
        Usuario u = usuarioDAO.autenticar(usuario, clave);
        if (u != null) {
            // Éxito: Limpiar contador de intentos fallidos
            LoginRateLimiter.registrarExito(rateLimitKey);

            // Prevención de Fijación de Sesión (Session Fixation Defense)
            HttpSession viejaSesion = req.getSession(false);
            if (viejaSesion != null) {
                viejaSesion.invalidate();
            }
            HttpSession nuevaSesion = req.getSession(true);
            nuevaSesion.setAttribute("usuario", u);

            log.info("AUTENTICACIÓN EXITOSA: Usuario '{}' (ID: {}) desde IP '{}'.", u.getUsername(), u.getId(), ipCliente);
            redirect(req, resp, "/dashboard");
        } else {
            // Fallo: Registrar intento para rate limiting
            LoginRateLimiter.registrarFallo(rateLimitKey);
            log.warn("FALLO DE AUTENTICACIÓN: Intento inválido para '{}' desde IP '{}'.", usuario, ipCliente);

            req.setAttribute("error", "Credenciales incorrectas. Verifica tu usuario y contraseña.");
            forward(req, resp, "/login.jsp");
        }
    }
}
