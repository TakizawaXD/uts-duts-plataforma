<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" isErrorPage="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aviso de la Plataforma • DUTS Unidades Tecnológicas de Santander</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/images/favicon.svg">
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/favicon.ico">

    <style>
        :root {
            --uts-green: #2f5c35;
            --uts-green-dark: #1b3d21;
            --uts-green-light: #8cb82b;
            --bg-canvas: #f8fafc;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --border-light: #e2e8f0;
            --card-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.04);
        }

        * { box-sizing: border-box; margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; }
        body { background-color: var(--bg-canvas); color: var(--text-main); min-height: 100vh; display: flex; flex-direction: column; }

        .error-header {
            background: #ffffff;
            height: 65px;
            padding: 0 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid var(--border-light);
        }
        .error-brand { display: flex; align-items: center; gap: 14px; text-decoration: none; }
        .error-brand img { height: 40px; object-fit: contain; }
        .brand-title { color: var(--uts-green); font-weight: 800; font-size: 19px; line-height: 1.1; }
        .brand-subtitle { color: var(--uts-green-light); font-weight: 700; font-size: 11px; text-transform: uppercase; letter-spacing: 1px; }

        .error-main {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }
        .error-card {
            background: #ffffff;
            border: 1px solid var(--border-light);
            border-radius: 20px;
            padding: 44px 36px;
            max-width: 620px;
            width: 100%;
            text-align: center;
            box-shadow: var(--card-shadow);
        }
        .error-title { font-size: 22px; font-weight: 800; color: var(--text-main); margin-bottom: 12px; }
        .error-desc { font-size: 14px; color: var(--text-muted); line-height: 1.6; margin-bottom: 28px; }

        .btn-primary-home {
            background: linear-gradient(135deg, var(--uts-green) 0%, var(--uts-green-dark) 100%);
            color: #ffffff;
            text-decoration: none;
            padding: 12px 24px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-secondary-back {
            background: #ffffff;
            color: #334155;
            text-decoration: none;
            padding: 12px 22px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 700;
            border: 1.5px solid var(--border-light);
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-left: 10px;
            cursor: pointer;
        }

        .error-footer {
            background: #ffffff;
            border-top: 1px solid var(--border-light);
            padding: 16px 30px;
            font-size: 12.5px;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
    </style>
</head>
<body>

    <header class="error-header">
        <a href="${pageContext.request.contextPath}/dashboard" class="error-brand">
            <img src="${pageContext.request.contextPath}/assets/images/logouts.png" alt="UTS Logo">
            <div>
                <span class="brand-title">DUTS</span>
                <span class="brand-subtitle">Unidades Tecnológicas de Santander</span>
            </div>
        </a>
    </header>

    <main class="error-main">
        <div class="error-card">
            <div style="width: 56px; height: 56px; border-radius: 50%; background: #f0fdf4; color: var(--uts-green); display: flex; align-items: center; justify-content: center; margin: 0 auto 18px;">
                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
            </div>
            <h1 class="error-title">
                <c:choose>
                    <c:when test="${not empty errorTitle}"><c:out value="${errorTitle}"/></c:when>
                    <c:otherwise>Notificación del Sistema DUTS</c:otherwise>
                </c:choose>
            </h1>
            <p class="error-desc">
                <c:choose>
                    <c:when test="${not empty errorMessage}"><c:out value="${errorMessage}"/></c:when>
                    <c:when test="${not empty pageContext.exception.message}"><c:out value="${pageContext.exception.message}"/></c:when>
                    <c:otherwise>La acción solicitada no pudo ser procesada. Te recomendamos regresar al panel principal para continuar navegando de forma segura.</c:otherwise>
                </c:choose>
            </p>
            <div>
                <a href="${pageContext.request.contextPath}/dashboard" class="btn-primary-home">
                    <span>Ir a mi Área Personal</span>
                </a>
                <button onclick="window.history.back()" class="btn-secondary-back" type="button">
                    <span>Regresar</span>
                </button>
            </div>
        </div>
    </main>

    <footer class="error-footer">
        <div>&copy; 2026 <strong>Unidades Tecnológicas de Santander – UTS</strong></div>
        <div>Mesa de Ayuda: <strong>soporte@uts.edu.co</strong></div>
    </footer>

</body>
</html>
