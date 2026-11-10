package co.edu.uts.duts.filter;

import javax.servlet.*;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * SecurityHeadersFilter: Interceptor de seguridad HTTP que inyecta cabeceras
 * estándar de protección recomendadas por OWASP para blindar la aplicación
 * contra Clickjacking, MIME-Sniffing y ataques XSS reflejados.
 */
public class SecurityHeadersFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Inicialización del filtro
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        if (response instanceof HttpServletResponse) {
            HttpServletResponse httpResp = (HttpServletResponse) response;

            // Previene que la plataforma sea incrustada en iframes externos (Anti-Clickjacking)
            httpResp.setHeader("X-Frame-Options", "SAMEORIGIN");

            // Impide que los navegadores adivinen el tipo MIME de los archivos (Anti-MIME-Sniffing)
            httpResp.setHeader("X-Content-Type-Options", "nosniff");

            // Activa el filtro XSS nativo de los navegadores clásicos
            httpResp.setHeader("X-XSS-Protection", "1; mode=block");

            // Control estricto de envío de encabezados Referrer
            httpResp.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");

            // Restricción de permisos innecesarios
            httpResp.setHeader("Permissions-Policy", "geolocation=(), microphone=(), camera=()");
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Limpieza del filtro
    }
}
