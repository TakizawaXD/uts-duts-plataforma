<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" isErrorPage="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Página no encontrada • DUTS Unidades Tecnológicas de Santander</title>
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
            --border-hover: #cbd5e1;
            --card-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.04);
            --card-shadow-hover: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
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
            background: rgba(239, 68, 68, 0.1);
            color: #dc2626;
            border: 1px solid rgba(239, 68, 68, 0.25);
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
            background: radial-gradient(circle at 50% 30%, rgba(140, 184, 43, 0.08) 0%, rgba(248, 250, 252, 1) 70%);
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
            background: linear-gradient(90deg, #1b3d21 0%, #2f5c35 50%, #8cb82b 100%);
        }

        .error-badge-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #f1f5f9;
            color: var(--text-muted);
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
            background: linear-gradient(135deg, var(--uts-green-dark) 0%, var(--uts-green) 50%, var(--uts-green-light) 100%);
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
            box-shadow: 0 6px 16px rgba(47, 92, 53, 0.35);
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
            border-color: var(--border-hover);
            transform: translateY(-2px);
        }

        .quick-nav-box {
            background: #f8fafc;
            border: 1px solid var(--border-light);
            border-radius: 14px;
            padding: 20px;
            text-align: left;
        }
        .quick-nav-title {
            font-size: 12.5px;
            font-weight: 800;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.6px;
            margin-bottom: 14px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .quick-nav-links {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 10px;
        }
        @media (max-width: 540px) {
            .quick-nav-links { grid-template-columns: 1fr; }
        }
        .quick-link-item {
            background: #ffffff;
            border: 1px solid var(--border-light);
            padding: 10px 14px;
            border-radius: 8px;
            text-decoration: none;
            color: var(--text-main);
            font-size: 13px;
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: all 0.2s;
        }
        .quick-link-item:hover {
            border-color: var(--uts-green-light);
            color: var(--uts-green);
            transform: translateX(3px);
            box-shadow: 0 2px 6px rgba(0,0,0,0.04);
        }
        .quick-link-item svg { color: var(--uts-green); }

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
        .error-footer-right a:hover { text-decoration: underline; }
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
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
            <span>Código de Estado: HTTP 404</span>
        </div>
    </header>

    <main class="error-main">
        <div class="error-card">
            <div class="error-badge-pill">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                Recurso No Localizado
            </div>

            <div class="error-number">404</div>

            <h1 class="error-title">Página o Servicio No Encontrado</h1>

            <p class="error-description">
                El enlace al que intentas acceder no existe en la plataforma DUTS, ha sido reubicado o la dirección escrita contiene un error tipográfico.
            </p>

            <div class="error-actions">
                <c:choose>
                    <c:when test="${not empty sessionScope.usuario}">
                        <a href="${pageContext.request.contextPath}/dashboard" class="btn-primary-home">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg>
                            <span>Ir al Área Personal</span>
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
                    <span>Volver atrás</span>
                </button>
            </div>

            <div class="quick-nav-box">
                <div class="quick-nav-title">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                    Secciones Principales de la Plataforma DUTS
                </div>
                <div class="quick-nav-links">
                    <a href="${pageContext.request.contextPath}/dashboard" class="quick-link-item">
                        <span>📊 Área Personal</span>
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"></polyline></svg>
                    </a>
                    <a href="${pageContext.request.contextPath}/transferencias" class="quick-link-item">
                        <span>💳 Billetera &amp; Transferencias</span>
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"></polyline></svg>
                    </a>
                    <a href="${pageContext.request.contextPath}/eventos" class="quick-link-item">
                        <span>📅 Eventos Universitarios</span>
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"></polyline></svg>
                    </a>
                    <a href="${pageContext.request.contextPath}/movimientos" class="quick-link-item">
                        <span>📄 Historial &amp; Facturas</span>
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"></polyline></svg>
                    </a>
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
            <a href="https://www.uts.edu.co" target="_blank" rel="noopener">Portal Institucional UTS</a>
        </div>
    </footer>

</body>
</html>
