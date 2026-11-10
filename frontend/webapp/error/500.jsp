<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" isErrorPage="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Eventualidad en el Servidor • DUTS Unidades Tecnológicas de Santander</title>
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
            --danger-red: #dc2626;
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
            background: rgba(220, 38, 38, 0.1);
            color: var(--danger-red);
            border: 1px solid rgba(220, 38, 38, 0.25);
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
            background: radial-gradient(circle at 50% 30%, rgba(220, 38, 38, 0.05) 0%, rgba(248, 250, 252, 1) 70%);
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
            background: linear-gradient(90deg, #991b1b 0%, #dc2626 50%, #f87171 100%);
        }

        .error-badge-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #fef2f2;
            color: #b91c1c;
            border: 1px solid #fecaca;
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
            background: linear-gradient(135deg, #7f1d1d 0%, #b91c1c 50%, #ef4444 100%);
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
            margin-bottom: 30px;
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
            margin-bottom: 30px;
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

        .diagnostic-card {
            background: #f8fafc;
            border: 1px solid var(--border-light);
            border-radius: 14px;
            padding: 18px 20px;
            text-align: left;
            margin-top: 10px;
        }
        .diag-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 12px;
            font-weight: 700;
            color: var(--text-muted);
            margin-bottom: 8px;
        }
        .diag-code {
            font-family: monospace;
            font-weight: 800;
            color: #b91c1c;
            background: #fef2f2;
            padding: 2px 8px;
            border-radius: 4px;
            border: 1px solid #fecaca;
        }
        .diag-notice {
            font-size: 12.5px;
            color: #475569;
            line-height: 1.5;
        }
        .diag-notice strong { color: #15803d; }

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
        <a href="${pageContext.request.contextPath}/dashboard" class="error-brand">
            <img src="${pageContext.request.contextPath}/assets/images/logouts.png" alt="UTS Logo">
            <div class="error-brand-text">
                <span class="brand-title">DUTS</span>
                <span class="brand-subtitle">Unidades Tecnológicas de Santander</span>
            </div>
        </a>
        <div class="header-status-badge">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
            <span>Código de Estado: HTTP 500</span>
        </div>
    </header>

    <main class="error-main">
        <div class="error-card">
            <div class="error-badge-pill">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                Eventualidad en el Servidor
            </div>

            <div class="error-number">500</div>

            <h1 class="error-title">Inconveniente al Procesar la Operación</h1>

            <p class="error-description">
                El servidor encontró una condición inesperada al procesar tu solicitud. El equipo técnico de la plataforma DUTS ha sido alertado automáticamente para resolverla.
            </p>

            <div class="error-actions">
                <a href="${pageContext.request.contextPath}/dashboard" class="btn-primary-home">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg>
                    <span>Volver al Dashboard Seguro</span>
                </a>
                <button onclick="window.location.reload()" class="btn-secondary-back" type="button">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="23 4 23 10 17 10"></polyline><polyline points="1 20 1 14 7 14"></polyline><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"></path></svg>
                    <span>Reintentar Operación</span>
                </button>
            </div>

            <div class="diagnostic-card">
                <div class="diag-header">
                    <span>SEGUIMIENTO DE AUDITORÍA UTS</span>
                    <span class="diag-code">FOLIO-ERR-${pageContext.session != null ? pageContext.session.id.substring(0, 8) : 'ANON'}</span>
                </div>
                <div class="diag-notice">
                    <strong>Tus puntos DUTS y saldo están seguros.</strong> Las operaciones y méritos universitarios se procesan con transacciones atómicas respaldadas en el libro mayor institucional.
                </div>
            </div>
        </div>
    </main>

    <footer class="error-footer">
        <div>
            &copy; 2026 <strong>Unidades Tecnológicas de Santander – UTS</strong> • Plataforma DUTS
        </div>
        <div class="error-footer-right">
            <span>Mesa de Ayuda TI: <strong>soporte@uts.edu.co</strong></span>
            <span>&bull;</span>
            <a href="${pageContext.request.contextPath}/movimientos">Verificar Extracto de Movimientos</a>
        </div>
    </footer>

</body>
</html>
