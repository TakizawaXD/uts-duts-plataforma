package co.edu.uts.duts.security;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * CsrfTokenManager: Generador y validador de tokens criptográficos contra ataques
 * de Falsificación de Peticiones en Sitios Cruzados (Cross-Site Request Forgery - CSRF).
 * Protege operaciones críticas como transferencias de fondos y cambios de perfil.
 */
public final class CsrfTokenManager {

    public static final String CSRF_SESSION_ATTR = "CSRF_TOKEN";
    public static final String CSRF_PARAM_NAME = "csrfToken";
    public static final String CSRF_HEADER_NAME = "X-CSRF-Token";

    private static final SecureRandom secureRandom = new SecureRandom();

    private CsrfTokenManager() {
    }

    /**
     * Obtiene o genera el token CSRF asociado a la sesión HTTP del usuario.
     */
    public static String obtenerOGenerarToken(HttpSession session) {
        if (session == null) {
            return "";
        }
        String token = (String) session.getAttribute(CSRF_SESSION_ATTR);
        if (token == null || token.trim().isEmpty()) {
            byte[] bytes = new byte[32];
            secureRandom.nextBytes(bytes);
            token = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
            session.setAttribute(CSRF_SESSION_ATTR, token);
        }
        return token;
    }

    /**
     * Valida que el token enviado en el formulario o en la cabecera HTTP
     * coincida exactamente con el token almacenado en la sesión activa.
     */
    public static boolean validarToken(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) {
            return false;
        }

        String sessionToken = (String) session.getAttribute(CSRF_SESSION_ATTR);
        if (sessionToken == null || sessionToken.trim().isEmpty()) {
            return false;
        }

        // Buscar token en parámetro de formulario o en encabezado HTTP
        String requestToken = req.getParameter(CSRF_PARAM_NAME);
        if (requestToken == null || requestToken.trim().isEmpty()) {
            requestToken = req.getHeader(CSRF_HEADER_NAME);
        }

        if (requestToken == null || requestToken.trim().isEmpty()) {
            return false;
        }

        // Comparación segura en tiempo constante para mitigar Timing Attacks
        return MessageDigestConstantTimeEquals(sessionToken, requestToken.trim());
    }

    private static boolean MessageDigestConstantTimeEquals(String a, String b) {
        if (a == null || b == null) return false;
        byte[] aBytes = a.getBytes();
        byte[] bBytes = b.getBytes();
        if (aBytes.length != bBytes.length) {
            return false;
        }
        int result = 0;
        for (int i = 0; i < aBytes.length; i++) {
            result |= aBytes[i] ^ bBytes[i];
        }
        return result == 0;
    }
}
