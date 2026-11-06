<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    HttpSession sesion = request.getSession(false);
    if (sesion != null && sesion.getAttribute("usuario") != null) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }
    request.getRequestDispatcher("/login.jsp").forward(request, response);
%>
