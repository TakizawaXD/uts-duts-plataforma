package co.edu.uts.duts.controller;

import co.edu.uts.duts.dao.PasswordResetDAO;
import co.edu.uts.duts.security.LoginRateLimiter;
import co.edu.uts.duts.security.SecurityUtils;
import co.edu.uts.duts.service.EmailService;
import co.edu.uts.duts.util.EnvConfig;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * RecuperarClaveServlet: recuperacion de contrasena en dos pasos.
 *
 * 1. POST action=solicitar (usuario + correo): si coinciden con una cuenta, se envia
 *    al correo registrado un enlace con un token de un solo uso. La respuesta es
 *    siempre la misma para no revelar que cuentas existen.
 * 2. GET ?token=... muestra el formulario de nueva clave; POST action=restablecer
 *    consume el token y actualiza la contrasena.
 */
@WebServlet("/recuperar-clave")
public class RecuperarClaveServlet extends BaseServlet {

    private static final Logger log = LoggerFactory.getLogger(RecuperarClaveServlet.class);
    private static final int MINUTOS_VALIDEZ_TOKEN = 30;
    private static final String MENSAJE_GENERICO =
            "Si los datos coinciden con una cuenta registrada, enviaremos a ese correo un enlace para restablecer la contraseña. "
            + "El enlace vence en " + MINUTOS_VALIDEZ_TOKEN + " minutos.";

    private final PasswordResetDAO resetDAO = new PasswordResetDAO();
    private final EmailService emailService = new EmailService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = getParamTrimmed(req, "token", null);
        if (token == null) {
            redirect(req, resp, "/index");
            return;
        }
        req.setAttribute("token", token);
        req.setAttribute("tokenValido", resetDAO.tokenValido(token));
        forward(req, resp, "/restablecer-clave.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if ("restablecer".equals(req.getParameter("action"))) {
            restablecer(req, resp);
        } else {
            solicitar(req, resp);
        }
    }

    private void solicitar(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");

        String ipCliente = SecurityUtils.obtenerIpCliente(req);
        String rateLimitKey = "recuperar:" + ipCliente;

        if (LoginRateLimiter.estaBloqueado(rateLimitKey)) {
            long segRestantes = LoginRateLimiter.obtenerSegundosRestantes(rateLimitKey);
            resp.setStatus(429);
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"Demasiadas solicitudes. Por favor espera "
                    + segRestantes + " segundos antes de volver a intentar.\"}");
            return;
        }
        // Cada solicitud cuenta para el limite, haya coincidencia o no: limita el envio de correos.
        LoginRateLimiter.registrarFallo(rateLimitKey);

        String usuario = getParamTrimmed(req, "usuario", null);
        String correo = getParamTrimmed(req, "correo", null);
        if (usuario == null || correo == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"Por favor completa todos los campos requeridos.\"}");
            return;
        }

        PasswordResetDAO.Titular titular = resetDAO.buscarTitular(usuario, correo);
        if (titular != null) {
            enviarEnlace(req, titular);
        } else {
            log.info("Solicitud de recuperacion sin coincidencia desde IP {}", ipCliente);
        }

        resp.setStatus(HttpServletResponse.SC_OK);
        resp.getWriter().write("{\"status\":\"success\",\"message\":\"" + MENSAJE_GENERICO + "\"}");
    }

    private void enviarEnlace(HttpServletRequest req, PasswordResetDAO.Titular titular) {
        String baseUrl = obtenerUrlBase(req);
        if (baseUrl == null) {
            log.error("APP_URL no esta configurada: no se puede generar el enlace de recuperacion.");
            return;
        }
        String token = resetDAO.crearToken(titular.usuarioId, MINUTOS_VALIDEZ_TOKEN);
        if (token == null) {
            return;
        }
        String enlace = baseUrl + "/recuperar-clave?token=" + token;
        String cuerpo = "Hola " + titular.nombre + ",\n\n"
                + "Recibimos una solicitud para restablecer la contraseña de tu cuenta DUTS UTS.\n"
                + "Abre este enlace para elegir una nueva contraseña (vence en " + MINUTOS_VALIDEZ_TOKEN + " minutos):\n\n"
                + enlace + "\n\n"
                + "Si no fuiste tú, ignora este correo: tu contraseña actual sigue funcionando.\n";

        boolean enviado = emailService.enviar(titular.correo, "Restablecer contraseña - DUTS UTS", cuerpo);
        if (enviado) {
            log.info("Enlace de recuperacion enviado al usuario ID {}", titular.usuarioId);
        } else if (esEntornoDesarrollo()) {
            // Solo en desarrollo local, sin SMTP, se muestra el enlace en el log para poder probar el flujo.
            log.warn("[DESARROLLO] SMTP no disponible. Enlace de recuperacion para usuario ID {}: {}", titular.usuarioId, enlace);
        }
    }

    private void restablecer(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = getParamTrimmed(req, "token", null);
        String nuevaClave = req.getParameter("nuevaClave");
        String confirmarClave = req.getParameter("confirmarClave");

        req.setAttribute("token", token);
        req.setAttribute("tokenValido", true);

        if (token == null || nuevaClave == null || confirmarClave == null) {
            req.setAttribute("error", "Por favor completa todos los campos.");
            forward(req, resp, "/restablecer-clave.jsp");
            return;
        }
        if (!nuevaClave.equals(confirmarClave)) {
            req.setAttribute("error", "Las contraseñas no coinciden.");
            forward(req, resp, "/restablecer-clave.jsp");
            return;
        }
        String errorFortaleza = SecurityUtils.validarFortalezaClave(nuevaClave);
        if (errorFortaleza != null) {
            req.setAttribute("error", errorFortaleza);
            forward(req, resp, "/restablecer-clave.jsp");
            return;
        }

        if (resetDAO.restablecerConToken(token, nuevaClave)) {
            req.setAttribute("exito", "Contraseña actualizada. Ya puedes iniciar sesión con tu nueva clave.");
            forward(req, resp, "/login.jsp");
        } else {
            req.setAttribute("tokenValido", false);
            forward(req, resp, "/restablecer-clave.jsp");
        }
    }

    private String obtenerUrlBase(HttpServletRequest req) {
        String appUrl = EnvConfig.get("APP_URL");
        if (appUrl != null) {
            return appUrl.endsWith("/") ? appUrl.substring(0, appUrl.length() - 1) : appUrl;
        }
        // Sin APP_URL solo se acepta el host de la peticion en desarrollo: en produccion
        // la cabecera Host la controla el cliente y permitiria enviar enlaces a otro dominio.
        if (esEntornoDesarrollo()) {
            return req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort() + req.getContextPath();
        }
        return null;
    }

    private boolean esEntornoDesarrollo() {
        String env = EnvConfig.get("APP_ENV", "production").toLowerCase();
        return env.equals("development") || env.equals("dev") || env.equals("local");
    }
}
