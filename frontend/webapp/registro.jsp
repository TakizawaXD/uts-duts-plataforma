<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es-CO">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0, viewport-fit=cover">
    <title>Registro de Estudiantes • DUTS UTS</title>
    
    <meta name="theme-color" content="#0f2e1b">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <meta name="mobile-web-app-capable" content="yes">
    
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/images/favicon.svg">
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/favicon.ico">
    <link rel="apple-touch-icon" href="${pageContext.request.contextPath}/assets/images/favicon.svg">
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800;900&family=Raleway:wght@400;500;600;700;800;900&family=Source+Sans+3:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --uts-verde-oscuro: #0f2e1b;
            --uts-verde-medio: #153c23;
            --uts-verde-escudo: #27522d;
            --uts-verde-hover: #32693a;
            --uts-verde-limon: #9ecc3b;
            --uts-papel: #f8f8f4;
            --uts-tinta: #1e293b;
            --uts-gris: #52606d;
            --uts-gris-claro: #94a3b8;
            --uts-borde: #e2e8f0;
            --uts-radio-base: 6px;
            --uts-radio-card: 12px;
            --uts-fuente-titulos: 'Raleway', sans-serif;
            --uts-fuente-cuerpo: 'Source Sans 3', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body, html {
            min-height: 100%;
            background-color: var(--uts-verde-oscuro);
            font-family: var(--uts-fuente-cuerpo);
            color: var(--uts-tinta);
            -webkit-font-smoothing: antialiased;
        }

        .bg-container {
            min-height: 100vh;
            width: 100%;
            background-image: linear-gradient(135deg, rgba(10, 30, 20, 0.92) 0%, rgba(15, 46, 27, 0.85) 50%, rgba(20, 60, 35, 0.75) 100%), 
                              url('${pageContext.request.contextPath}/assets/images/uts-bg.png');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }

        .main-wrapper {
            display: flex;
            width: 100%;
            max-width: 1140px;
            justify-content: space-between;
            align-items: center;
            gap: 48px;
            margin: 0 auto;
        }
        
        /* Lateral Izquierdo Informativo */
        .left-content {
            color: #ffffff;
            flex: 1;
            max-width: 520px;
        }

        .left-content .logo-link {
            display: inline-block;
            margin-bottom: 20px;
            transition: transform 0.2s;
        }

        .left-content .logo-link:hover {
            transform: scale(1.02);
        }

        .left-content img.logo {
            max-width: 220px;
            height: auto;
            display: block;
            filter: drop-shadow(0 4px 12px rgba(0,0,0,0.4));
        }

        .badge-institucional {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: rgba(158, 204, 59, 0.18);
            border: 1px solid rgba(158, 204, 59, 0.4);
            color: #d1fae5;
            padding: 5px 12px;
            border-radius: 9999px;
            font-size: 11.5px;
            font-weight: 700;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            margin-bottom: 16px;
            font-family: var(--uts-fuente-titulos);
        }

        .left-content h1 {
            font-family: var(--uts-fuente-titulos);
            font-size: clamp(28px, 4vw, 44px);
            margin: 0 0 16px 0;
            line-height: 1.15;
            font-weight: 900;
            color: #ffffff;
            letter-spacing: -0.5px;
        }

        .left-content h1 span {
            color: var(--uts-verde-limon);
        }

        .left-content p.descripcion {
            font-size: clamp(14.5px, 1.8vw, 16.5px);
            margin-bottom: 28px;
            line-height: 1.55;
            color: #e2e8f0;
        }

        .feature-tags {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .feature-tag {
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.18);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            padding: 8px 14px;
            border-radius: var(--uts-radio-base);
            font-size: 13px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #f1f5f9;
        }

        .feature-tag svg {
            color: var(--uts-verde-limon);
            flex-shrink: 0;
        }

        /* Tarjeta de Registro */
        .login-card {
            background-color: #ffffff;
            border-radius: var(--uts-radio-card);
            padding: 36px 32px;
            width: 100%;
            max-width: 520px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.35), 0 4px 12px rgba(0, 0, 0, 0.1);
            border-top: 5px solid var(--uts-verde-escudo);
            flex-shrink: 0;
        }

        .card-header {
            margin-bottom: 20px;
        }

        .card-header h3 {
            font-family: var(--uts-fuente-titulos);
            font-size: 24px;
            font-weight: 800;
            margin: 0 0 4px 0;
            color: var(--uts-verde-oscuro);
        }

        .card-header p.subtitle {
            margin: 0;
            color: var(--uts-gris);
            font-size: 13.5px;
        }

        /* Banner de Bono de Bienvenida */
        .bono-banner {
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
            color: #166534;
            padding: 10px 14px;
            border-radius: var(--uts-radio-base);
            font-size: 12.5px;
            font-weight: 600;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            line-height: 1.35;
        }

        .bono-pill {
            background: var(--uts-verde-escudo);
            color: #ffffff;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 11.5px;
            font-weight: 800;
            letter-spacing: 0.5px;
            white-space: nowrap;
        }

        .alert-error {
            background-color: #fef2f2;
            color: #991b1b;
            padding: 12px 14px;
            border-radius: var(--uts-radio-base);
            margin-bottom: 18px;
            font-size: 13px;
            border: 1px solid #fecaca;
            display: flex;
            align-items: center;
            gap: 8px;
            line-height: 1.4;
        }

        /* Formulario Responsive */
        .auth-form {
            display: flex;
            flex-wrap: wrap;
            gap: 14px;
        }

        .form-group {
            width: 100%;
        }

        .form-group.half {
            width: calc(50% - 7px);
        }

        .form-group label {
            display: block;
            font-family: var(--uts-fuente-titulos);
            font-size: 12px;
            font-weight: 700;
            color: #334155;
            margin-bottom: 5px;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        .input-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }

        .form-group input, 
        .form-group select {
            width: 100%;
            height: 44px;
            padding: 0 12px;
            border: 1.5px solid var(--uts-borde);
            border-radius: var(--uts-radio-base);
            font-family: var(--uts-fuente-cuerpo);
            font-size: 15px;
            color: var(--uts-tinta);
            background-color: #ffffff;
            transition: border-color 0.2s, box-shadow 0.2s;
            appearance: none;
            -webkit-appearance: none;
        }

        .form-group select {
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%2352606d' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 12px center;
            background-size: 16px;
            padding-right: 36px;
            cursor: pointer;
        }

        .form-group input:focus, 
        .form-group select:focus {
            outline: none;
            border-color: var(--uts-verde-escudo);
            box-shadow: 0 0 0 3px rgba(39, 82, 45, 0.12);
        }

        /* Contenedor relativo para inputs de contraseña con botón Ver */
        .password-field-wrap {
            position: relative;
            width: 100%;
            display: flex;
            align-items: center;
        }

        .password-field-wrap input {
            padding-right: 44px !important;
        }

        .btn-toggle-eye {
            position: absolute;
            right: 8px;
            top: 50%;
            transform: translateY(-50%);
            background: transparent;
            border: none;
            cursor: pointer;
            padding: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--uts-gris);
            border-radius: 4px;
            transition: color 0.15s, background-color 0.15s;
            user-select: none;
            -webkit-tap-highlight-color: transparent;
            z-index: 2;
        }

        .btn-toggle-eye:hover {
            color: var(--uts-verde-escudo);
            background-color: rgba(39, 82, 45, 0.08);
        }

        .btn-toggle-eye:focus {
            outline: 2px solid var(--uts-verde-limon);
        }

        /* Feedback de Coincidencia de Contraseñas en Tiempo Real */
        .match-status-msg {
            font-size: 12.5px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 7px;
            padding: 7px 12px;
            border-radius: 6px;
            transition: all 0.2s ease;
            animation: fadeInMatch 0.2s ease;
            width: 100%;
        }

        @keyframes fadeInMatch {
            from { opacity: 0; transform: translateY(-4px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .match-status-msg.error {
            background-color: #fef2f2;
            color: #b91c1c;
            border: 1.5px solid #fecaca;
        }

        .match-status-msg.success {
            background-color: #f0fdf4;
            color: #15803d;
            border: 1.5px solid #bbf7d0;
        }

        .input-match-error {
            border-color: #dc2626 !important;
            background-color: #fffafa !important;
            box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.15) !important;
        }

        .input-match-success {
            border-color: #16a34a !important;
            background-color: #fafffb !important;
            box-shadow: 0 0 0 3px rgba(22, 163, 74, 0.15) !important;
        }

        /* Panel de Seguridad y Requisitos Exigentes en Tiempo Real */
        .password-security-panel {
            width: 100%;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: var(--uts-radio-base);
            padding: 12px 14px;
            margin-top: 4px;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .security-meter-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 11.5px;
            font-weight: 700;
            color: #475569;
        }

        .security-meter-label {
            text-transform: uppercase;
            letter-spacing: 0.4px;
            font-family: var(--uts-fuente-titulos);
        }

        .security-meter-value {
            font-weight: 800;
            transition: color 0.25s ease;
        }

        /* Barra de Medidor de Fuerza de 4 segmentos */
        .security-meter-bar {
            display: flex;
            gap: 5px;
            height: 6px;
            width: 100%;
        }

        .meter-segment {
            flex: 1;
            height: 100%;
            background-color: #e2e8f0;
            border-radius: 99px;
            transition: background-color 0.3s ease;
        }

        /* Lista de Requisitos Exigentes en Tiempo Real */
        .password-requirements-list {
            list-style: none;
            margin: 0;
            padding: 0;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 6px 10px;
        }

        @media (max-width: 600px) {
            .password-requirements-list {
                grid-template-columns: 1fr;
            }
        }

        .req-item {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 11.5px;
            color: #64748b;
            font-weight: 600;
            transition: color 0.2s ease, transform 0.2s ease;
        }

        .req-item.met {
            color: #166534;
            font-weight: 700;
        }

        .req-item.unmet {
            color: #64748b;
        }

        .req-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 15px;
            height: 15px;
            border-radius: 50%;
            font-size: 9.5px;
            font-weight: 900;
            background-color: #cbd5e1;
            color: #ffffff;
            flex-shrink: 0;
            transition: all 0.2s ease;
        }

        .req-item.met .req-icon {
            background-color: #16a34a;
            color: #ffffff;
            transform: scale(1.08);
        }

        .btn-submit {
            background-color: var(--uts-verde-escudo);
            color: #ffffff;
            border: none;
            width: 100%;
            height: 46px;
            border-radius: var(--uts-radio-base);
            font-family: var(--uts-fuente-titulos);
            font-size: 15px;
            font-weight: 800;
            cursor: pointer;
            margin-top: 8px;
            transition: all 0.2s ease;
            box-shadow: 0 4px 12px rgba(39, 82, 45, 0.25);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-submit:hover {
            background-color: var(--uts-verde-hover);
            transform: translateY(-1.5px);
            box-shadow: 0 6px 18px rgba(39, 82, 45, 0.35);
        }

        .btn-submit:active {
            transform: translateY(0);
        }

        .card-footer {
            margin-top: 20px;
            text-align: center;
            padding-top: 16px;
            border-top: 1px solid var(--uts-borde);
        }

        .guest-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 13.5px;
            font-weight: 600;
            color: var(--uts-verde-escudo);
            text-decoration: none;
            margin-bottom: 8px;
            transition: color 0.15s;
        }

        .guest-link:hover {
            text-decoration: underline;
            color: var(--uts-verde-hover);
        }

        .help-text {
            font-size: 12px;
            color: var(--uts-gris-claro);
        }

        .help-text a {
            color: var(--uts-gris);
            text-decoration: none;
        }

        /* ============================================================== */
        /* RESPONSIVE DESIGN INTELIGENTE PARA DISPOSITIVOS MÓVILES        */
        /* ============================================================== */

        /* Tablets y Pantallas Medianas (<= 992px) */
        @media (max-width: 992px) {
            .bg-container {
                padding: 30px 16px;
                background-attachment: scroll;
            }

            .main-wrapper {
                flex-direction: column;
                gap: 32px;
                max-width: 580px;
            }

            .left-content {
                max-width: 100%;
                text-align: center;
            }

            .left-content img.logo {
                margin: 0 auto 14px auto;
                max-width: 200px;
            }

            .feature-tags {
                justify-content: center;
            }

            .login-card {
                max-width: 100%;
            }
        }

        /* Celulares y Smartphones (<= 640px) */
        @media (max-width: 640px) {
            .bg-container {
                padding: 16px 12px;
                align-items: flex-start;
            }

            .main-wrapper {
                gap: 20px;
                width: 100%;
            }

            .left-content {
                padding: 10px 4px 0 4px;
            }

            .left-content img.logo {
                max-width: 170px;
                margin-bottom: 10px;
            }

            .badge-institucional {
                font-size: 10.5px;
                padding: 4px 10px;
                margin-bottom: 12px;
            }

            .left-content h1 {
                font-size: 26px;
                margin-bottom: 10px;
            }

            .left-content p.descripcion {
                font-size: 14px;
                margin-bottom: 16px;
                line-height: 1.45;
            }

            /* Simplificar tags de características en móviles */
            .feature-tags {
                gap: 8px;
            }

            .feature-tag {
                font-size: 11.5px;
                padding: 6px 10px;
            }

            /* Tarjeta de registro adaptada a pantalla completa de celular */
            .login-card {
                padding: 24px 18px;
                border-radius: var(--uts-radio-base);
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            }

            .card-header h3 {
                font-size: 21px;
            }

            .card-header p.subtitle {
                font-size: 12.5px;
            }

            .bono-banner {
                padding: 8px 10px;
                font-size: 11.5px;
                gap: 8px;
                margin-bottom: 16px;
            }

            .bono-pill {
                font-size: 10.5px;
                padding: 3px 6px;
            }

            /* Formulario en móvil: 1 columna completa para máxima comodidad táctil */
            .auth-form {
                gap: 12px;
            }

            .form-group.half {
                width: 100%;
            }

            /* Font-size 16px OBLIGATORIO en inputs para evitar auto-zoom molesto en iOS Safari */
            .form-group input, 
            .form-group select {
                height: 46px;
                font-size: 16px;
                padding: 0 12px;
            }

            .btn-submit {
                height: 48px;
                font-size: 16px;
                margin-top: 6px;
            }

            .card-footer {
                margin-top: 16px;
                padding-top: 14px;
            }

            .guest-link {
                font-size: 13px;
            }
        }

        /* Pantallas muy compactas (iPhone SE, 320px - 360px) */
        @media (max-width: 360px) {
            .login-card {
                padding: 20px 14px;
            }

            .left-content h1 {
                font-size: 23px;
            }

            .feature-tags {
                display: none; /* Ocultar badges redundantes para enfocar la pantalla en el formulario */
            }
        }
    </style>
</head>
<body>
    <div class="bg-container">
        <div class="main-wrapper">
            
            <!-- LATERAL IZQUIERDO INSTITUCIONAL -->
            <div class="left-content">
                <a href="${pageContext.request.contextPath}/index" title="Ir a Inicio UTS" class="logo-link">
                    <img src="${pageContext.request.contextPath}/assets/images/logouts.png" alt="Logo UTS • Unidades Tecnológicas de Santander" class="logo">
                </a>
                
                <div>
                    <span class="badge-institucional">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                        Ecosistema de Méritos DUTS
                    </span>
                </div>
                
                <h1>Comunidad Uteísta<br><span>Méritos &amp; Reconocimiento</span></h1>
                
                <p class="descripcion">Crea tu cuenta institucional y comienza a gestionar tus méritos DUTS, transferencias seguras entre compañeros y tu avance hacia la meta de grado de 70.000 DUTS.</p>
                
                <div class="feature-tags">
                    <div class="feature-tag">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                        <span>Historial DUTS</span>
                    </div>
                    <div class="feature-tag">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="22" y1="2" x2="11" y2="13"></line><polygon points="22 2 15 22 11 13 2 9 22 2"></polygon></svg>
                        <span>Transferencias</span>
                    </div>
                    <div class="feature-tag">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                        <span>Acceso Seguro 24/7</span>
                    </div>
                </div>
            </div>

            <!-- TARJETA DE REGISTRO RESPONSIVE -->
            <div class="login-card">
                <div class="card-header">
                    <h3>Crea tu cuenta</h3>
                    <p class="subtitle">Portal oficial para estudiantes y docentes UTS</p>
                </div>

                <div class="bono-banner">
                    <span class="bono-pill">+500 DUTS</span>
                    <span>Bono institucional acreditado al registrarte por primera vez.</span>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert-error">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                        <span><c:out value="${error}" /></span>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/registro" method="POST" class="auth-form" autocomplete="on">
                    
                    <div class="form-group half">
                        <label for="nombre_completo">Nombre Completo</label>
                        <input type="text" id="nombre_completo" name="nombre_completo" required placeholder="Nombres y Apellidos" value="<c:out value='${param.nombre_completo}'/>" autocomplete="name">
                    </div>

                    <div class="form-group half">
                        <label for="codigo_estudiantil">Código Estudiantil</label>
                        <input type="text" id="codigo_estudiantil" name="codigo_estudiantil" required placeholder="Ej: 1005... o T000..." value="<c:out value='${param.codigo_estudiantil}'/>" autocomplete="username">
                    </div>
                    
                    <div class="form-group half">
                        <label for="username">Nombre de Usuario</label>
                        <input type="text" id="username" name="username" required placeholder="Tu usuario de ingreso" value="<c:out value='${param.username}'/>" autocomplete="nickname">
                    </div>

                    <div class="form-group half">
                        <label for="correo">Correo Institucional</label>
                        <input type="email" id="correo" name="correo" required placeholder="ejemplo@correo.uts.edu.co" value="<c:out value='${param.correo}'/>" autocomplete="email">
                    </div>

                    <div class="form-group half">
                        <label for="programa_academico">Programa Académico</label>
                        <select id="programa_academico" name="programa_academico" required>
                            <option value="" disabled selected>Seleccione su carrera...</option>
                            <optgroup label="Facultad de Ciencias Naturales e Ingenierías">
                                <option value="Ingeniería de Sistemas">Ingeniería de Sistemas</option>
                                <option value="Tecnología en Desarrollo de Sistemas Informáticos">Tecnología en Desarrollo de Sistemas Informáticos</option>
                                <option value="Ingeniería en IA y Ciencia de Datos">Ingeniería en Inteligencia Artificial y Ciencia de Datos</option>
                                <option value="Ingeniería Electromecánica">Ingeniería Electromecánica</option>
                                <option value="Tecnología en Mantenimiento Electromecánico">Tecnología en Operación y Mantenimiento Electromecánico</option>
                                <option value="Tecnología en Telecomunicaciones">Tecnología en Gestión de Sistemas de Telecomunicaciones</option>
                                <option value="Tecnología en Recursos Energéticos">Tecnología en Gestión de Recursos Energéticos</option>
                                <option value="Tecnología Topográfica">Tecnología en Levantamientos Topográficos</option>
                            </optgroup>
                            <optgroup label="Facultad de Ciencias Socioeconómicas y Empresariales">
                                <option value="Administración de Empresas">Administración de Empresas</option>
                                <option value="Tecnología en Gestión Empresarial">Tecnología en Gestión Empresarial</option>
                                <option value="Contaduría Pública">Contaduría Pública</option>
                                <option value="Tecnología en Contabilidad Financiera">Tecnología en Contabilidad Financiera</option>
                                <option value="Administración Turística y Hotelera">Administración Turística y Hotelera</option>
                                <option value="Tecnología en Gestión Comercial">Tecnología en Gestión Comercial</option>
                                <option value="Tecnología en Banca y Finanzas">Tecnología en Gestión Bancaria y Financiera</option>
                            </optgroup>
                        </select>
                    </div>

                    <div class="form-group half">
                        <label for="semestre">Semestre</label>
                        <input type="number" id="semestre" name="semestre" required min="1" max="10" placeholder="Semestre (1 al 10)" value="<c:out value='${param.semestre}'/>">
                    </div>
                    
                    <div class="form-group half">
                        <label for="clave">Contraseña</label>
                        <div class="password-field-wrap">
                            <input type="password" id="clave" name="clave" required minlength="8" placeholder="Crea tu contraseña" autocomplete="new-password">
                            <button type="button" class="btn-toggle-eye" id="btnToggleClave" aria-label="Mostrar contraseña" title="Mostrar contraseña">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                            </button>
                        </div>
                    </div>

                    <div class="form-group half">
                        <label for="confirmar_clave">Confirmar Contraseña</label>
                        <div class="password-field-wrap">
                            <input type="password" id="confirmar_clave" name="confirmar_clave" required minlength="8" placeholder="Repite tu contraseña" autocomplete="new-password">
                            <button type="button" class="btn-toggle-eye" id="btnToggleConfirmarClave" aria-label="Mostrar contraseña" title="Mostrar contraseña">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                            </button>
                        </div>
                    </div>

                    <!-- MENSAJE DE COINCIDENCIA EN TIEMPO REAL -->
                    <div class="form-group" id="matchFeedbackWrap" style="display: none; margin-top: -4px;">
                        <div id="matchFeedback" class="match-status-msg">
                            <span id="matchIcon"></span>
                            <span id="matchText"></span>
                        </div>
                    </div>

                    <!-- PANEL DE SEGURIDAD EXIGENTE Y REQUISITOS EN TIEMPO REAL -->
                    <div class="form-group">
                        <div class="password-security-panel">
                            <div class="security-meter-header">
                                <span class="security-meter-label">Seguridad de la Contraseña</span>
                                <span class="security-meter-value" id="strengthLabel" style="color: #64748b;">Esperando contraseña...</span>
                            </div>

                            <div class="security-meter-bar">
                                <div class="meter-segment" id="seg1"></div>
                                <div class="meter-segment" id="seg2"></div>
                                <div class="meter-segment" id="seg3"></div>
                                <div class="meter-segment" id="seg4"></div>
                            </div>

                            <ul class="password-requirements-list">
                                <li class="req-item" id="reqLength">
                                    <span class="req-icon">✕</span>
                                    <span>Mínimo 8 caracteres</span>
                                </li>
                                <li class="req-item" id="reqUpper">
                                    <span class="req-icon">✕</span>
                                    <span>Al menos una mayúscula (A-Z)</span>
                                </li>
                                <li class="req-item" id="reqLower">
                                    <span class="req-icon">✕</span>
                                    <span>Al menos una minúscula (a-z)</span>
                                </li>
                                <li class="req-item" id="reqNumber">
                                    <span class="req-icon">✕</span>
                                    <span>Al menos un número (0-9)</span>
                                </li>
                                <li class="req-item" id="reqSpecial">
                                    <span class="req-icon">✕</span>
                                    <span>Al menos un símbolo (@, $, !, %, *, #, etc.)</span>
                                </li>
                            </ul>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <button type="submit" class="btn-submit" id="btnSubmit">
                            <span>Completar Registro</span>
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
                        </button>
                    </div>
                </form>

                <div class="card-footer">
                    <a href="${pageContext.request.contextPath}/index" class="guest-link">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"></path><polyline points="10 17 15 12 10 7"></polyline><line x1="15" y1="12" x2="3" y2="12"></line></svg>
                        <span>¿Ya tienes cuenta? Ingresa aquí</span>
                    </a>
                    <div class="help-text">Soporte institucional: <a href="mailto:duts@correo.uts.edu.co">duts@correo.uts.edu.co</a></div>
                </div>
            </div>

        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const inputClave = document.getElementById('clave');
            const inputConfirmar = document.getElementById('confirmar_clave');
            const btnToggleClave = document.getElementById('btnToggleClave');
            const btnToggleConfirmar = document.getElementById('btnToggleConfirmarClave');
            
            const matchWrap = document.getElementById('matchFeedbackWrap');
            const matchFeedback = document.getElementById('matchFeedback');
            const matchIcon = document.getElementById('matchIcon');
            const matchText = document.getElementById('matchText');
            
            const strengthLabel = document.getElementById('strengthLabel');
            const seg1 = document.getElementById('seg1');
            const seg2 = document.getElementById('seg2');
            const seg3 = document.getElementById('seg3');
            const seg4 = document.getElementById('seg4');
            
            const reqLength = document.getElementById('reqLength');
            const reqUpper = document.getElementById('reqUpper');
            const reqLower = document.getElementById('reqLower');
            const reqNumber = document.getElementById('reqNumber');
            const reqSpecial = document.getElementById('reqSpecial');
            
            const form = document.querySelector('.auth-form');

            const iconEyeOpen = '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>';
            const iconEyeClosed = '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path><line x1="1" y1="1" x2="23" y2="23"></line></svg>';

            // 1. Mostrar / Ocultar Contraseña ("que se pueda ver")
            function setupToggle(btn, input) {
                if (!btn || !input) return;
                btn.addEventListener('click', function(e) {
                    e.preventDefault();
                    const isPassword = input.type === 'password';
                    input.type = isPassword ? 'text' : 'password';
                    btn.innerHTML = isPassword ? iconEyeClosed : iconEyeOpen;
                    const estado = isPassword ? 'Ocultar contraseña' : 'Ver contraseña';
                    btn.setAttribute('aria-label', estado);
                    btn.title = estado;
                    input.focus();
                });
            }
            setupToggle(btnToggleClave, inputClave);
            setupToggle(btnToggleConfirmar, inputConfirmar);

            // 2. Actualización de requisitos individuales en tiempo real
            function updateReq(element, isMet) {
                if (!element) return;
                const icon = element.querySelector('.req-icon');
                if (isMet) {
                    element.classList.add('met');
                    element.classList.remove('unmet');
                    if (icon) icon.textContent = '✓';
                } else {
                    element.classList.remove('met');
                    element.classList.add('unmet');
                    if (icon) icon.textContent = '✕';
                }
            }

            // 3. Renderizado en tiempo real de seguridad de contraseña
            function validatePasswordSecurity() {
                const val = inputClave.value || '';
                
                const hasLength = val.length >= 8;
                const hasUpper = /[A-Z]/.test(val);
                const hasLower = /[a-z]/.test(val);
                const hasNumber = /[0-9]/.test(val);
                const hasSpecial = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?~`]/.test(val);

                updateReq(reqLength, hasLength);
                updateReq(reqUpper, hasUpper);
                updateReq(reqLower, hasLower);
                updateReq(reqNumber, hasNumber);
                updateReq(reqSpecial, hasSpecial);

                let score = 0;
                if (hasLength) score++;
                if (hasUpper) score++;
                if (hasLower) score++;
                if (hasNumber) score++;
                if (hasSpecial) score++;

                // Reiniciar segmentos
                [seg1, seg2, seg3, seg4].forEach(s => {
                    if (s) s.style.backgroundColor = '#e2e8f0';
                });

                if (val.length === 0) {
                    strengthLabel.textContent = 'Esperando contraseña...';
                    strengthLabel.style.color = '#64748b';
                } else if (score <= 2) {
                    strengthLabel.textContent = 'Débil (insegura)';
                    strengthLabel.style.color = '#ef4444';
                    if (seg1) seg1.style.backgroundColor = '#ef4444';
                } else if (score === 3) {
                    strengthLabel.textContent = 'Media (moderada)';
                    strengthLabel.style.color = '#f97316';
                    if (seg1) seg1.style.backgroundColor = '#f97316';
                    if (seg2) seg2.style.backgroundColor = '#f97316';
                } else if (score === 4) {
                    strengthLabel.textContent = 'Fuerte (buena)';
                    strengthLabel.style.color = '#84cc16';
                    if (seg1) seg1.style.backgroundColor = '#84cc16';
                    if (seg2) seg2.style.backgroundColor = '#84cc16';
                    if (seg3) seg3.style.backgroundColor = '#84cc16';
                } else if (score === 5) {
                    strengthLabel.textContent = 'Muy Fuerte (excelente)';
                    strengthLabel.style.color = '#16a34a';
                    if (seg1) seg1.style.backgroundColor = '#16a34a';
                    if (seg2) seg2.style.backgroundColor = '#16a34a';
                    if (seg3) seg3.style.backgroundColor = '#16a34a';
                    if (seg4) seg4.style.backgroundColor = '#16a34a';
                }

                validateMatch();
            }

            // 4. Validación de coincidencia en tiempo real ("si no coinciden diga que no son iguales")
            function validateMatch() {
                const clave = inputClave.value || '';
                const confirmar = inputConfirmar.value || '';

                if (!confirmar) {
                    matchWrap.style.display = 'none';
                    inputConfirmar.classList.remove('input-match-error', 'input-match-success');
                    return;
                }

                matchWrap.style.display = 'block';

                if (clave === confirmar) {
                    matchFeedback.className = 'match-status-msg success';
                    matchIcon.innerHTML = '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>';
                    matchText.textContent = 'Las contraseñas coinciden correctamente';
                    inputConfirmar.classList.remove('input-match-error');
                    inputConfirmar.classList.add('input-match-success');
                } else {
                    matchFeedback.className = 'match-status-msg error';
                    matchIcon.innerHTML = '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>';
                    matchText.textContent = 'Las contraseñas no son iguales';
                    inputConfirmar.classList.remove('input-match-success');
                    inputConfirmar.classList.add('input-match-error');
                }
            }

            // Escuchar eventos en tiempo real
            inputClave.addEventListener('input', validatePasswordSecurity);
            inputClave.addEventListener('keyup', validatePasswordSecurity);
            inputConfirmar.addEventListener('input', validateMatch);
            inputConfirmar.addEventListener('keyup', validateMatch);

            // 5. Verificación al enviar el formulario
            if (form) {
                form.addEventListener('submit', function(e) {
                    const clave = inputClave.value || '';
                    const confirmar = inputConfirmar.value || '';

                    const hasLength = clave.length >= 8;
                    const hasUpper = /[A-Z]/.test(clave);
                    const hasLower = /[a-z]/.test(clave);
                    const hasNumber = /[0-9]/.test(clave);
                    const hasSpecial = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?~`]/.test(clave);

                    if (!hasLength || !hasUpper || !hasLower || !hasNumber || !hasSpecial) {
                        e.preventDefault();
                        alert('La contraseña no cumple con los requisitos de seguridad institucionales exigidos:\n\n• Mínimo 8 caracteres\n• Al menos una mayúscula (A-Z)\n• Al menos una minúscula (a-z)\n• Al menos un número (0-9)\n• Al menos un caracter especial (@, $, !, %, *, #, etc.)');
                        inputClave.focus();
                        return false;
                    }

                    if (clave !== confirmar) {
                        e.preventDefault();
                        matchWrap.style.display = 'block';
                        matchFeedback.className = 'match-status-msg error';
                        matchIcon.innerHTML = '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>';
                        matchText.textContent = 'Las contraseñas no son iguales';
                        inputConfirmar.classList.add('input-match-error');
                        inputConfirmar.focus();
                        return false;
                    }
                });
            }
        });
    </script>
</body>
</html>
