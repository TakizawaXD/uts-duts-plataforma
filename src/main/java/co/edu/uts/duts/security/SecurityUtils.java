package co.edu.uts.duts.security;

import javax.servlet.http.HttpServletRequest;
import java.io.BufferedInputStream;
import java.io.InputStream;

/**
 * SecurityUtils: Colección de utilidades defensivas para sanitización de entradas,
 * validación de firmas binarias de archivos (Magic Bytes) y detección de IPs de clientes.
 */
public final class SecurityUtils {

    private SecurityUtils() {
    }

    /**
     * Obtiene la dirección IP real del cliente, incluso tras balanceadores o proxies inversos.
     */
    public static String obtenerIpCliente(HttpServletRequest request) {
        if (request == null) return "0.0.0.0";
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("X-Real-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        return ip != null ? ip : "127.0.0.1";
    }

    /**
     * Valida la firma binaria (Magic Bytes) de un archivo para garantizar
     * que sea una imagen auténtica (JPEG, PNG, WEBP o GIF) y no un script camuflado.
     */
    public static boolean esFirmaImagenValida(InputStream inputStream) {
        if (inputStream == null) return false;
        try {
            InputStream in = inputStream.markSupported() ? inputStream : new BufferedInputStream(inputStream);
            in.mark(16);
            byte[] header = new byte[12];
            int read = in.read(header);
            in.reset();

            if (read < 4) {
                return false;
            }

            // JPEG: FF D8 FF
            if ((header[0] & 0xFF) == 0xFF && (header[1] & 0xFF) == 0xD8 && (header[2] & 0xFF) == 0xFF) {
                return true;
            }

            // PNG: 89 50 4E 47
            if ((header[0] & 0xFF) == 0x89 && (header[1] & 0xFF) == 0x50 && 
                (header[2] & 0xFF) == 0x4E && (header[3] & 0xFF) == 0x47) {
                return true;
            }

            // GIF: 47 49 46 38
            if (header[0] == 'G' && header[1] == 'I' && header[2] == 'F' && header[3] == '8') {
                return true;
            }

            // WEBP: RIFF....WEBP
            if (header[0] == 'R' && header[1] == 'I' && header[2] == 'F' && header[3] == 'F' &&
                header[8] == 'W' && header[9] == 'E' && header[10] == 'B' && header[11] == 'P') {
                return true;
            }

            return false;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Sanitiza cadenas de texto para prevenir inyecciones XSS y ataques de control.
     */
    public static String sanitizarTexto(String texto) {
        if (texto == null) return null;
        return texto.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#x27;")
                    .replace("/", "&#x2F;")
                    .replace("\0", "")
                    .trim();
    }

    /**
     * Sanitiza el nombre de un archivo para impedir vulnerabilidades de Path Traversal.
     */
    public static String sanitizarNombreArchivo(String nombreOriginal) {
        if (nombreOriginal == null) return "archivo";
        String limpio = nombreOriginal.replace("..", "").replace("/", "").replace("\\", "").replace("\0", "").trim();
        return limpio.isEmpty() ? "archivo" : limpio;
    }
}
