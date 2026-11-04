package co.edu.uts.duts.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Inicialización del filtro de seguridad
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        
        String path = req.getRequestURI().substring(req.getContextPath().length());
        
        // 1. Recursos estáticos y utilitarios públicos
        boolean isStaticResource = path.startsWith("/assets/") || path.equals("/favicon.ico") || path.equals("/favicon.svg")
                                || path.equals("/manifest.json") || path.equals("/sw.js") || path.startsWith("/downloads/")
                                || path.equals("/descargar-app");
                                
        // 2. Endpoints de API pública
        boolean isApiEndpoint = path.startsWith("/api/");
        
        // 3. Páginas de error institucionales
        boolean isErrorPage = path.startsWith("/error/") || path.equals("/404.jsp") || path.equals("/500.jsp") 
                            || path.equals("/403.jsp") || path.equals("/error.jsp");
                            
        // 4. Páginas y acciones de autenticación
        boolean isAuthPage = path.equals("/login") || path.equals("/registro") 
                            || path.equals("/login.jsp") || path.equals("/registro.jsp")
                            || path.equals("/logout");
        
        // 5. Verificación de sesión de usuario
        HttpSession session = req.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("usuario") != null);
        
        if (isLoggedIn || isAuthPage || isStaticResource || isApiEndpoint || isErrorPage || path.equals("/")) {
            chain.doFilter(request, response);
        } else {
            res.sendRedirect(req.getContextPath() + "/login");
        }
    }

    @Override
    public void destroy() {
        // Limpieza del filtro
    }
}
