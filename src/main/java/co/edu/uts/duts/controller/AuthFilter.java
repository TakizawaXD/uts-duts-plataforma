package co.edu.uts.duts.controller;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        
        String path = req.getRequestURI().substring(req.getContextPath().length());
        
        boolean isStaticResource = path.startsWith("/assets/");
        boolean isApiEndpoint = path.startsWith("/api/");
        boolean isAuthPage = path.equals("/login") || path.equals("/registro") 
                            || path.equals("/login.jsp") || path.equals("/registro.jsp")
                            || path.equals("/logout");
        
        HttpSession session = req.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("usuario") != null);
        
        if (isLoggedIn || isAuthPage || isStaticResource || isApiEndpoint || path.equals("/")) {
            chain.doFilter(request, response);
        } else {
            res.sendRedirect(req.getContextPath() + "/login");
        }
    }

    @Override
    public void destroy() {}
}
