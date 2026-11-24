<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="referrer" content="no-referrer">
    <meta name="robots" content="noindex">
    <title>Restablecer contraseña | DUTS UTS</title>
    <link rel="icon" href="${pageContext.request.contextPath}/favicon.svg" type="image/svg+xml">
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0; min-height: 100vh; display: flex; align-items: center; justify-content: center;
            font-family: system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
            background: #f3f6f4; color: #1f2a22; padding: 16px;
        }
        .card {
            width: 100%; max-width: 420px; background: #fff; border-radius: 14px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, .08); padding: 28px;
        }
        .badge { font-size: 12px; font-weight: 600; color: #2f5c35; text-transform: uppercase; letter-spacing: .04em; }
        h1 { font-size: 22px; margin: 6px 0 18px; }
        label { display: block; font-size: 14px; font-weight: 600; margin: 14px 0 6px; }
        input[type=password] {
            width: 100%; padding: 11px 12px; border: 1px solid #c9d3cb; border-radius: 8px; font-size: 15px;
        }
        input[type=password]:focus { outline: 2px solid #2f5c35; outline-offset: 1px; }
        .hint { font-size: 12px; color: #5b6b5f; margin-top: 8px; }
        button, .btn {
            display: inline-block; width: 100%; margin-top: 20px; padding: 12px; border: 0; border-radius: 8px;
            background: #2f5c35; color: #fff; font-size: 15px; font-weight: 600; cursor: pointer;
            text-align: center; text-decoration: none;
        }
        .alerta { padding: 10px 12px; border-radius: 8px; font-size: 14px; margin-bottom: 8px; }
        .alerta--error { background: #fdecec; color: #8a1c1c; }
    </style>
</head>
<body>
    <main class="card">
        <span class="badge">Seguridad Institucional UTS</span>
        <h1>Restablecer contraseña</h1>

        <c:choose>
            <c:when test="${tokenValido}">
                <c:if test="${not empty error}">
                    <div class="alerta alerta--error" role="alert"><c:out value="${error}"/></div>
                </c:if>
                <form action="${pageContext.request.contextPath}/recuperar-clave" method="POST" autocomplete="off">
                    <input type="hidden" name="action" value="restablecer">
                    <input type="hidden" name="token" value="<c:out value='${token}'/>">

                    <label for="nuevaClave">Nueva contraseña</label>
                    <input type="password" id="nuevaClave" name="nuevaClave" required minlength="8" autocomplete="new-password">

                    <label for="confirmarClave">Confirmar nueva contraseña</label>
                    <input type="password" id="confirmarClave" name="confirmarClave" required minlength="8" autocomplete="new-password">

                    <p class="hint">Mínimo 8 caracteres, con mayúscula, minúscula, número y un caracter especial.</p>
                    <button type="submit">Guardar nueva contraseña</button>
                </form>
            </c:when>
            <c:otherwise>
                <div class="alerta alerta--error" role="alert">
                    Este enlace no es válido, ya se usó o venció. Solicita uno nuevo desde "¿Olvidó su clave?" en la página de inicio.
                </div>
                <a class="btn" href="${pageContext.request.contextPath}/index">Volver al inicio</a>
            </c:otherwise>
        </c:choose>
    </main>
</body>
</html>
