<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Acceder - DUTS UTS</title>
    <style>
        * { box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body, html {
            margin: 0; padding: 0; height: 100%;
        }
        .bg-container {
            min-height: 100vh;
            /* Usamos contextPath para garantizar que encuentre la imagen si está bien guardada */
            background-image: linear-gradient(to right, rgba(10, 30, 20, 0.85) 0%, rgba(10, 30, 20, 0.4) 100%), url('${pageContext.request.contextPath}/assets/images/uts-bg.png');
            background-size: cover;
            background-position: center;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .main-wrapper {
            display: flex;
            width: 100%;
            max-width: 1100px;
            justify-content: space-between;
            align-items: center;
            gap: 50px;
        }
        
        /* CONTENIDO IZQUIERDO */
        .left-content {
            color: white;
            flex: 1;
            max-width: 550px;
        }
        .left-content img.logo {
            max-width: 250px;
            margin-bottom: 10px;
        }
        .left-content h2 {
            font-size: 22px;
            font-weight: normal;
            margin: 0 0 10px 0;
            color: #d0d0d0;
        }
        .tag-green {
            display: inline-block;
            background-color: #2b5d43;
            color: white;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: bold;
            margin-bottom: 25px;
            letter-spacing: 0.5px;
        }
        .left-content h1 {
            font-size: 46px;
            margin: 0 0 20px 0;
            line-height: 1.1;
            font-weight: 800;
        }
        .left-content p {
            font-size: 17px;
            margin-bottom: 35px;
            line-height: 1.5;
            color: #e0e0e0;
        }
        .feature-tags {
            display: flex;
            gap: 15px;
        }
        .feature-tag {
            background-color: rgba(0,0,0,0.4);
            border: 1px solid rgba(255,255,255,0.2);
            padding: 8px 12px;
            border-radius: 6px;
            font-size: 13px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* TARJETA DE LOGIN (DERECHA) */
        .login-card {
            background-color: white;
            border-radius: 12px;
            padding: 40px;
            width: 100%;
            max-width: 420px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.4);
            color: #333;
        }
        .login-card h3 {
            font-size: 24px;
            margin: 0 0 5px 0;
            color: #1a1a1a;
        }
        .login-card p.subtitle {
            margin: 0 0 25px 0;
            color: #666;
            font-size: 13px;
        }
        .btn-sso {
            background-color: #2e7d32;
            color: white;
            border: none;
            width: 100%;
            padding: 12px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            margin-bottom: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            transition: background 0.3s;
        }
        .btn-sso:hover { background-color: #1b5e20; }
        
        .divider {
            display: flex;
            align-items: center;
            text-align: center;
            color: #999;
            font-size: 12px;
            margin-bottom: 20px;
        }
        .divider::before, .divider::after {
            content: '';
            flex: 1;
            border-bottom: 1px solid #e0e0e0;
        }
        .divider:not(:empty)::before { margin-right: .5em; }
        .divider:not(:empty)::after { margin-left: .5em; }

        .auth-form label {
            display: block;
            font-size: 12px;
            color: #333;
            margin-bottom: 6px;
            font-weight: 600;
        }
        .auth-form input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            margin-bottom: 15px;
            font-size: 14px;
        }
        .auth-form input:focus {
            border-color: #2e7d32;
            outline: none;
        }
        
        .forgot-link {
            display: block;
            text-align: right;
            font-size: 12px;
            color: #2e7d32;
            text-decoration: none;
            margin-top: -5px;
            margin-bottom: 20px;
        }
        .forgot-link:hover { text-decoration: underline; }

        .btn-submit {
            background-color: white;
            color: #333;
            border: 1px solid #333;
            width: 100%;
            padding: 12px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            margin-bottom: 20px;
            transition: all 0.2s;
        }
        .btn-submit:hover {
            background-color: #f5f5f5;
        }

        .guest-link {
            display: block;
            text-align: center;
            font-size: 13px;
            color: #555;
            text-decoration: underline;
            margin-bottom: 10px;
        }
        .help-text {
            text-align: center;
            font-size: 11px;
            color: #888;
        }

        .alert-error {
            background-color: #ffebee;
            color: #c62828;
            padding: 10px;
            border-radius: 6px;
            margin-bottom: 15px;
            font-size: 13px;
            border: 1px solid #ffcdd2;
        }
        .alert-success {
            background-color: #e8f5e9;
            color: #2e7d32;
            padding: 10px;
            border-radius: 6px;
            margin-bottom: 15px;
            font-size: 13px;
            border: 1px solid #c8e6c9;
        }

        /* Responsividad para móviles */
        @media (max-width: 900px) {
            .main-wrapper {
                flex-direction: column;
            }
            .left-content {
                text-align: center;
                margin-bottom: 30px;
            }
            .feature-tags {
                justify-content: center;
                flex-wrap: wrap;
            }
        }
    </style>
</head>
<body>
    <div class="bg-container">
        <div class="main-wrapper">
            
            <!-- CONTENIDO IZQUIERDO (Adaptado para DUTS) -->
            <div class="left-content">
                <a href="${pageContext.request.contextPath}/login" title="Ir a Inicio" style="display: inline-block;">
                    <img src="${pageContext.request.contextPath}/assets/images/logouts.png" alt="Logo UTS" class="logo">
                </a>
                <h2>¡Lo hacemos posible!</h2>
                <div class="tag-green">• PLATAFORMA FINANCIERA</div>
                
                <h1>Simulación<br>Tecnología<br>Educativa</h1>
                
                <p>Tus saldos, actividades y eventos en un solo lugar.<br>Ingresa con tu cuenta institucional para continuar.</p>
                
                <div class="feature-tags">
                    <div class="feature-tag">Historial DUTS</div>
                    <div class="feature-tag">Transferencias</div>
                    <div class="feature-tag">Acceso 24/7</div>
                </div>
            </div>

            <!-- TARJETA DE LOGIN (ESTILO BLANCO / CLARO) -->
            <div class="login-card">
                <h3>Accede a la plataforma</h3>
                <p class="subtitle">Estudiantes y docentes</p>

                <c:if test="${not empty error}">
                    <div class="alert-error"><c:out value="${error}" /></div>
                </c:if>
                <c:if test="${not empty exito}">
                    <div class="alert-success"><c:out value="${exito}" /></div>
                </c:if>

                <button type="button" class="btn-sso">
                    Ingresar con su correo institucional
                </button>

                <div class="divider">o con usuario y contraseña</div>

                <form action="${pageContext.request.contextPath}/login" method="POST" class="auth-form">
                    <label for="usuario">Nombre de usuario</label>
                    <input type="text" id="usuario" name="usuario" required placeholder="Nombre de usuario" value="<c:out value='${param.usuario}'/>">
                    
                    <label for="clave">Contraseña</label>
                    <input type="password" id="clave" name="clave" required placeholder="Contraseña">
                    
                    <a href="#" class="forgot-link">¿Olvidó su nombre de usuario o contraseña?</a>
                    
                    <!-- Boton Acceder blanco con borde oscuro -->
                    <button type="submit" class="btn-submit">Acceder</button>
                </form>

                <a href="${pageContext.request.contextPath}/registro" class="guest-link">Crear cuenta nueva / Registrarse</a>
                <div class="help-text">Ayuda: duts@correo.uts.edu.co</div>
            </div>

        </div>
    </div>
</body>
</html>
