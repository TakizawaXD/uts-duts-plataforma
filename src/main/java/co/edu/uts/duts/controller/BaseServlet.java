package co.edu.uts.duts.controller;

import co.edu.uts.duts.model.Usuario;
import co.edu.uts.duts.security.CsrfTokenManager;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * BaseServlet: Controlador base que centraliza la gestión de sesiones,
 * redirecciones, despachos JSP, mensajes flash, tokens CSRF y utilidades de parseo
 * para evitar duplicación de código (anti-patrón spaghetti).
 */
public abstract class BaseServlet extends HttpServlet {

    private static final Logger log = LoggerFactory.getLogger(BaseServlet.class);

    /**
     * Obtiene el usuario autenticado en la sesión HTTP actual, o null si no existe.
     */
    protected Usuario getUsuarioSesion(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session != null) {
            Object obj = session.getAttribute("usuario");
            if (obj instanceof Usuario) {
                return (Usuario) obj;
            }
        }
        return null;
    }

    /**
     * Verifica si la petición cuenta con una sesión activa y un usuario válido.
     */
    protected boolean esUsuarioAutenticado(HttpServletRequest req) {
        return getUsuarioSesion(req) != null;
    }

    /**
     * Verifica si el usuario actual posee rol de Administrador (rolId == 2).
     */
    protected boolean esUsuarioAdmin(HttpServletRequest req) {
        Usuario u = getUsuarioSesion(req);
        return u != null && u.getRolId() == 2;
    }

    /**
     * Valida la sesión y redirige a /login si no está autenticado.
     * Retorna true si está autenticado, false si ya se envió la redirección.
     */
    protected boolean asegurarAutenticacion(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if (!esUsuarioAutenticado(req)) {
            redirect(req, resp, "/login");
            return false;
        }
        return true;
    }

    /**
     * Valida que el usuario tenga privilegios de Administrador.
     * Si no es admin, envía un error HTTP 403 Forbidden.
     */
    protected boolean asegurarAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if (!asegurarAutenticacion(req, resp)) {
            return false;
        }
        if (!esUsuarioAdmin(req)) {
            log.warn("ACCESO NO AUTORIZADO: Usuario '{}' intentó ejecutar acción de administrador.", 
                    getUsuarioSesion(req).getUsername());
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso restringido a administradores.");
            return false;
        }
        return true;
    }

    /**
     * Valida el token CSRF para peticiones POST/PUT/DELETE.
     * Retorna true si el token es legítimo, false si fue falsificado o expiró.
     */
    protected boolean validarCsrf(HttpServletRequest req) {
        boolean valido = CsrfTokenManager.validarToken(req);
        if (!valido) {
            log.warn("ALERTA DE SEGURIDAD CSRF: Petición desde IP '{}' con token inválido o ausente en '{}'.",
                    req.getRemoteAddr(), req.getRequestURI());
            setFlashError(req, "La sesión de seguridad o token CSRF ha expirado. Por favor inténtalo de nuevo.");
        }
        return valido;
    }

    /**
     * Mueve los mensajes flash ('flashSuccess' y 'flashError') de la sesión
     * a los atributos de la petición para su consumo en las vistas JSP.
     */
    protected void transferirFlashMessages(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session != null) {
            Object flashSuccess = session.getAttribute("flashSuccess");
            if (flashSuccess != null) {
                req.setAttribute("flashSuccess", flashSuccess);
                session.removeAttribute("flashSuccess");
            }
            Object flashError = session.getAttribute("flashError");
            if (flashError != null) {
                req.setAttribute("flashError", flashError);
                session.removeAttribute("flashError");
            }
        }
    }

    /**
     * Registra un mensaje flash de éxito en la sesión.
     */
    protected void setFlashSuccess(HttpServletRequest req, String mensaje) {
        HttpSession session = req.getSession(true);
        session.setAttribute("flashSuccess", mensaje);
    }

    /**
     * Registra un mensaje flash de error en la sesión.
     */
    protected void setFlashError(HttpServletRequest req, String mensaje) {
        HttpSession session = req.getSession(true);
        session.setAttribute("flashError", mensaje);
    }

    /**
     * Despacha la petición a la vista JSP correspondiente, inyectando el token CSRF.
     */
    protected void forward(HttpServletRequest req, HttpServletResponse resp, String jspPath) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            String token = CsrfTokenManager.obtenerOGenerarToken(session);
            req.setAttribute("csrfToken", token);
        }
        req.getRequestDispatcher(jspPath).forward(req, resp);
    }

    /**
     * Realiza una redirección segura anteponiendo el contextPath de la aplicación.
     */
    protected void redirect(HttpServletRequest req, HttpServletResponse resp, String relativePath) throws IOException {
        String cleanPath = relativePath.startsWith("/") ? relativePath : "/" + relativePath;
        resp.sendRedirect(req.getContextPath() + cleanPath);
    }

    /**
     * Parsea un parámetro entero de la petición con valor por defecto seguro.
     */
    protected int getParamInt(HttpServletRequest req, String paramName, int defaultValue) {
        String val = req.getParameter(paramName);
        if (val == null || val.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(val.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    /**
     * Parsea un parámetro numérico decimal de la petición con valor por defecto seguro.
     */
    protected double getParamDouble(HttpServletRequest req, String paramName, double defaultValue) {
        String val = req.getParameter(paramName);
        if (val == null || val.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Double.parseDouble(val.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    /**
     * Obtiene un parámetro de texto limpio de espacios en blanco.
     */
    protected String getParamTrimmed(HttpServletRequest req, String paramName, String defaultValue) {
        String val = req.getParameter(paramName);
        if (val == null || val.trim().isEmpty()) {
            return defaultValue;
        }
        return val.trim();
    }
}
