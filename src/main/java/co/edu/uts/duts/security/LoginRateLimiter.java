package co.edu.uts.duts.security;
 
import co.edu.uts.duts.util.EnvConfig;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * LoginRateLimiter: Mecanismo de mitigación contra ataques de fuerza bruta y ataques
 * de diccionario en el portal de acceso (/login). Bloquea accesos maliciosos repetidos.
 */
public final class LoginRateLimiter {

    private static final Logger log = LoggerFactory.getLogger(LoginRateLimiter.class);

    private static int getMaxIntentos() {
        return EnvConfig.getInt("SECURITY_MAX_LOGIN_ATTEMPTS", 5);
    }

    private static long getVentanaTiempoMs() {
        return EnvConfig.getInt("SECURITY_WINDOW_MINUTES", 3) * 60 * 1000L;
    }

    private static long getDuracionBloqueoMs() {
        return EnvConfig.getInt("SECURITY_LOCKOUT_MINUTES", 3) * 60 * 1000L;
    }

    private static final Map<String, IntentoRegistro> intentosMap = new ConcurrentHashMap<>();

    private static class IntentoRegistro {
        int contador;
        long primerIntentoMs;
        long bloqueadoHastaMs;

        IntentoRegistro(long ahora) {
            this.contador = 1;
            this.primerIntentoMs = ahora;
            this.bloqueadoHastaMs = 0;
        }
    }

    private LoginRateLimiter() {
    }

    /**
     * Comprueba si una dirección IP o usuario se encuentra temporalmente bloqueado.
     */
    public static boolean estaBloqueado(String claveIdentificador) {
        if (claveIdentificador == null) return false;
        limpiarRegistrosAntiguos();

        IntentoRegistro registro = intentosMap.get(claveIdentificador);
        if (registro == null) {
            return false;
        }

        long ahora = System.currentTimeMillis();
        if (registro.bloqueadoHastaMs > ahora) {
            return true;
        }

        // Si expiró el bloqueo, resetear
        if (registro.bloqueadoHastaMs > 0 && ahora >= registro.bloqueadoHastaMs) {
            intentosMap.remove(claveIdentificador);
            return false;
        }

        return false;
    }

    /**
     * Calcula los segundos restantes que le quedan a un bloqueo activo.
     */
    public static long obtenerSegundosRestantes(String claveIdentificador) {
        IntentoRegistro registro = intentosMap.get(claveIdentificador);
        if (registro == null || registro.bloqueadoHastaMs <= System.currentTimeMillis()) {
            return 0;
        }
        return (registro.bloqueadoHastaMs - System.currentTimeMillis()) / 1000L;
    }

    /**
     * Registra un intento de autenticación fallido.
     */
    public static void registrarFallo(String claveIdentificador) {
        if (claveIdentificador == null) return;
        long ahora = System.currentTimeMillis();

        intentosMap.compute(claveIdentificador, (k, reg) -> {
            if (reg == null || (ahora - reg.primerIntentoMs > getVentanaTiempoMs() && reg.bloqueadoHastaMs <= ahora)) {
                return new IntentoRegistro(ahora);
            }

            reg.contador++;
            if (reg.contador >= getMaxIntentos()) {
                reg.bloqueadoHastaMs = ahora + getDuracionBloqueoMs();
                log.warn("BLOQUEO DE SEGURIDAD: Identificador '{}' bloqueado por {} intentos fallidos.", claveIdentificador, reg.contador);
            }
            return reg;
        });
    }

    /**
     * Limpia los intentos fallidos tras un inicio de sesión exitoso.
     */
    public static void registrarExito(String claveIdentificador) {
        if (claveIdentificador != null) {
            intentosMap.remove(claveIdentificador);
        }
    }

    private static void limpiarRegistrosAntiguos() {
        long ahora = System.currentTimeMillis();
        if (intentosMap.size() > 500) {
            intentosMap.entrySet().removeIf(entry -> {
                IntentoRegistro r = entry.getValue();
                return (ahora - r.primerIntentoMs > VENTANA_TIEMPO_MS * 2) && (r.bloqueadoHastaMs < ahora);
            });
        }
    }
}
