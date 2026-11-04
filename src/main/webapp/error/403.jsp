<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" isErrorPage="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>403 - Acceso Restringido • DUTS Unidades Tecnológicas de Santander</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/images/favicon.svg">
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/favicon.ico">

    <style>
        :root {
            --uts-green: #2f5c35;
            --uts-green-dark: #1b3d21;
            --uts-green-light: #8cb82b;
            --uts-green-soft: #ecfdf5;
            --bg-canvas: #f8fafc;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --border-light: #e2e8f0;
            --warning-gold: #d97706;
            --warning-bg: #fffbeb;
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
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
        }
        .error-brand {
            display: flex;
            align-items: center;
            gap: 14px;
            text-decoration: none;
        }
        .error-brand img { height: 40px; object-fit: contain; }
        .error-brand-text { display: flex; flex-direction: column; }
        .brand-title { color: var(--uts-green); font-weight: 800; font-size: 19px; line-height: 1.1; }
        .brand-subtitle { color: var(--uts-green-light); font-weight: 700; font-size: 11px; text-transform: uppercase; letter-spacing: 1px; }

        .header-status-badge {
            background: rgba(217, 119, 6, 0.1);
            color: var(--warning-gold);
            border: 1px solid rgba(217, 119, 6, 0.25);
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .error-main {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
            position: relative;
            background: radial-gradient(circle at 50% 30%, rgba(217, 119, 6, 0.08) 0%, rgba(248, 250, 252, 1) 70%);
        }

        .error-card {
            background: #ffffff;
            border: 1px solid var(--border-light);
            border-radius: 20px;
            padding: 48px 40px;
            max-width: 680px;
            width: 100%;
            text-align: center;
            box-shadow: var(--card-shadow);
            position: relative;
            overflow: hidden;
        }
        .error-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(90deg, #92400e 0%, #d97706 50%, #f59e0b 100%);
        }

        .error-badge-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: var(--warning-bg);
            color: #b45309;
            border: 1px solid rgba(217, 119, 6, 0.2);
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            margin-bottom: 20px;
        }

        .error-number {
            font-size: 88px;
            font-weight: 900;
            line-height: 1;
            letter-spacing: -3px;
            background: linear-gradient(135deg, #78350f 0%, #b45309 50%, #f59e0b 100%);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 12px;
        }

        .error-title {
            font-size: 24px;
            font-weight: 800;
            color: var(--text-main);
            margin-bottom: 12px;
            line-height: 1.3;
        }

        .error-description {
            font-size: 15px;
            color: var(--text-muted);
            line-height: 1.6;
            margin-bottom: 32px;
            max-width: 520px;
            margin-left: auto;
            margin-right: auto;
        }

        .error-actions {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 14px;
            flex-wrap: wrap;
            margin-bottom: 36px;
        }

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
            box-shadow: 0 4px 12px rgba(47, 92, 53, 0.25);
            transition: all 0.2s;
        }
        .btn-primary-home:hover {
            background: linear-gradient(135deg, var(--uts-green-light) 0%, var(--uts-green) 100%);
            transform: translateY(-2px);
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
            transition: all 0.2s;
            cursor: pointer;
        }
        .btn-secondary-back:hover {
            background: #f8fafc;
            transform: translateY(-2px);
        }

        .security-policy-box {
            background: #fffbeb;
            border: 1px solid #fde68a;
            border-radius: 14px;
            padding: 18px;
            text-align: left;
            display: flex;
            align-items: flex-start;
            gap: 14px;
        }
        .security-icon { color: #d97706; flex-shrink: 0; margin-top: 2px; }
        .security-text h4 { font-size: 13.5px; font-weight: 800; color: #92400e; margin-bottom: 4px; }
        .security-text p { font-size: 12.5px; color: #78350f; line-height: 1.5; }

        .error-footer {
            background: #ffffff;
            border-top: 1px solid var(--border-light);
            padding: 18px 30px;
            font-size: 12.5px;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 12px;
        }
        .error-footer-right { display: flex; align-items: center; gap: 16px; }
        .error-footer-right a { color: var(--uts-green); text-decoration: none; font-weight: 600; }
    </style>
</head>
<body>

    <header class="error-header">
        <a href="${not empty sessionScope.usuario ? pageContext.request.contextPath.concat('/dashboard') : pageContext.request.contextPath.concat('/login')}" class="error-brand">
            <img src="${pageContext.request.contextPath}/assets/images/logouts.png" alt="UTS Logo">
            <div class="error-brand-text">
                <span class="brand-title">DUTS</span>
                <span class="brand-subtitle">Unidades Tecnológicas de Santander</span>
            </div>
        </a>
        <div class="header-status-badge">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
            <span>Código de Estado: HTTP 403</span>
        </div>
    </header>

    <main class="error-main">
        <div class="error-card">
            <div class="error-badge-pill">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
                Control de Acceso Institucional
            </div>

            <div class="error-number">403</div>

            <h1 class="error-title">Acceso Denegado o Restringido</h1>

            <p class="error-description">
                No dispones de los privilegios institucionales necesarios para visualizar o gestionar este recurso. Esta sección está reservada para roles autorizados o administradores de la plataforma DUTS UTS.
            </p>

            <div class="error-actions">
                <c:choose>
                    <c:when test="${not empty sessionScope.usuario}">
                        <a href="${pageContext.request.contextPath}/dashboard" class="btn-primary-home">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg>
                            <span>Volver a Mi Área Personal</span>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn-primary-home">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"></path><polyline points="10 17 15 12 10 7"></polyline><line x1="15" y1="12" x2="3" y2="12"></line></svg>
                            <span>Iniciar Sesión en DUTS</span>
                        </a>
                    </c:otherwise>
                </c:choose>
                <button onclick="window.history.back()" class="btn-secondary-back" type="button">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
                    <span>Regresar</span>
                </button>
            </div>

            <div class="security-policy-box">
                <div class="security-icon">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>
                </div>
                <div class="security-text">
                    <h4>Políticas de Seguridad y Méritos DUTS</h4>
                    <p>
                        Si consideras que deberías tener acceso a este módulo o requieres permisos de Administrador de Semillero o Docente, comunícate con la Dirección de Tecnologías de Información UTS.
                    </p>
                </div>
            </div>
        </div>
    </main>

    <footer class="error-footer">
        <div>
            &copy; 2026 <strong>Unidades Tecnológicas de Santander – UTS</strong> • Plataforma DUTS
        </div>
        <div class="error-footer-right">
            <span>Soporte Bucaramanga: <strong>soporte@uts.edu.co</strong></span>
            <span>&bull;</span>
            <a href="${pageContext.request.contextPath}/logout">Cerrar Sesión e Ingresar con otra Cuenta</a>
        </div>
    </footer>

</body>
</html>
