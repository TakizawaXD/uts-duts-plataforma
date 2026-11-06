package co.edu.uts.duts.filter;

import co.edu.uts.duts.security.CsrfTokenManager;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * AuthFilter: Guardián de seguridad y control de acceso del sistema UTS DUTS.
 * Protege rutas privadas, previene la navegación directa a vistas JSP y asegura
 * la disponibilidad del token CSRF para formularios dinámicos.
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Inicialización
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        
        String path = req.getRequestURI().substring(req.getContextPath().length());

        // 1. Protección contra acceso directo a plantillas JSP protegidas (MVC Enforcing)
        if (path.equals("/dashboard.jsp")) {
            res.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }
        if (path.equals("/eventos.jsp")) {
            res.sendRedirect(req.getContextPath() + "/eventos");
            return;
        }
        if (path.equals("/transferencias.jsp")) {
            res.sendRedirect(req.getContextPath() + "/transferencias");
            return;
        }
        if (path.equals("/movimientos.jsp")) {
            res.sendRedirect(req.getContextPath() + "/movimientos");
            return;
        }
        if (path.equals("/perfil.jsp")) {
            res.sendRedirect(req.getContextPath() + "/perfil");
            return;
        }
        
        // 2. Recursos estáticos y utilitarios públicos
        boolean isStaticResource = path.startsWith("/assets/") || path.equals("/favicon.ico") || path.equals("/favicon.svg")
                                || path.equals("/manifest.json") || path.equals("/sw.js") || path.startsWith("/downloads/")
                                || path.equals("/descargar-app");
                                
        // 3. Endpoints de API pública
        boolean isApiEndpoint = path.startsWith("/api/");
        
        // 4. Páginas de error institucionales
        boolean isErrorPage = path.startsWith("/error/") || path.equals("/404.jsp") || path.equals("/500.jsp") 
                            || path.equals("/403.jsp") || path.equals("/error.jsp");
                            
        // 5. Páginas y acciones de autenticación
        boolean isAuthPage = path.equals("/login") || path.equals("/registro") 
                            || path.equals("/login.jsp") || path.equals("/registro.jsp")
                            || path.equals("/logout") || path.equals("/index") || path.equals("/index.jsp");
        
        // 6. Verificación de sesión de usuario
        HttpSession session = req.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("usuario") != null);

        // Precalentar o propagar token CSRF si la sesión existe
        if (session != null) {
            String csrfToken = CsrfTokenManager.obtenerOGenerarToken(session);
            req.setAttribute("csrfToken", csrfToken);
        }
        
        if (isLoggedIn || isAuthPage || isStaticResource || isApiEndpoint || isErrorPage || path.equals("/") || path.isEmpty()) {
            chain.doFilter(request, response);
        } else {
            res.sendRedirect(req.getContextPath() + "/index");
        }
    }

    @Override
    public void destroy() {
        // Limpieza
    }
}
