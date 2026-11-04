<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro - DUTS UTS</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/images/favicon.svg">
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/favicon.ico">
    <link rel="apple-touch-icon" href="${pageContext.request.contextPath}/assets/images/favicon.svg">
    <style>
        * { box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body, html { margin: 0; padding: 0; height: 100%; }
        .bg-container {
            min-height: 100vh;
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
        
        .left-content { color: white; flex: 1; max-width: 550px; }
        .left-content img.logo { max-width: 250px; margin-bottom: 10px; }
        .left-content h2 { font-size: 22px; font-weight: normal; margin: 0 0 10px 0; color: #d0d0d0; }
        .tag-green {
            display: inline-block; background-color: #2b5d43; color: white;
            padding: 6px 12px; border-radius: 20px; font-size: 11px; font-weight: bold;
            margin-bottom: 25px; letter-spacing: 0.5px;
        }
        .left-content h1 { font-size: 46px; margin: 0 0 20px 0; line-height: 1.1; font-weight: 800; }
        .left-content p { font-size: 17px; margin-bottom: 35px; line-height: 1.5; color: #e0e0e0; }
        .feature-tags { display: flex; gap: 15px; }
        .feature-tag {
            background-color: rgba(0,0,0,0.4); border: 1px solid rgba(255,255,255,0.2);
            padding: 8px 12px; border-radius: 6px; font-size: 13px; display: flex; align-items: center; gap: 8px;
        }

        .login-card {
            background-color: white; border-radius: 12px; padding: 40px;
            width: 100%; max-width: 480px; box-shadow: 0 15px 35px rgba(0,0,0,0.4); color: #333;
        }
        .login-card h3 { font-size: 24px; margin: 0 0 5px 0; color: #1a1a1a; }
        .login-card p.subtitle { margin: 0 0 20px 0; color: #666; font-size: 13px; }
        
        .auth-form {
            display: flex; flex-wrap: wrap; gap: 15px;
        }
        .input-group { flex: 1 1 100%; }
        .input-half { flex: 1 1 calc(50% - 15px); }

        .auth-form label { display: block; font-size: 12px; color: #333; margin-bottom: 6px; font-weight: 600; }
        .auth-form input { width: 100%; padding: 12px; border: 1px solid #ccc; border-radius: 6px; font-size: 14px; }
        .auth-form input:focus { border-color: #2e7d32; outline: none; }
        
        .btn-submit {
            background-color: #2e7d32; color: white; border: none; width: 100%;
            padding: 12px; border-radius: 6px; font-size: 14px; font-weight: bold;
            cursor: pointer; margin-top: 10px; margin-bottom: 20px; transition: background 0.3s;
        }
        .btn-submit:hover { background-color: #1b5e20; }

        .guest-link { display: block; text-align: center; font-size: 13px; color: #555; text-decoration: underline; margin-bottom: 10px; }
        .help-text { text-align: center; font-size: 11px; color: #888; }

        .alert-error { background-color: #ffebee; color: #c62828; padding: 10px; border-radius: 6px; margin-bottom: 15px; font-size: 13px; border: 1px solid #ffcdd2; width: 100%; }

        @media (max-width: 900px) {
            .main-wrapper { flex-direction: column; }
            .left-content { text-align: center; margin-bottom: 30px; }
            .feature-tags { justify-content: center; flex-wrap: wrap; }
            .input-half { flex: 1 1 100%; }
        }
    </style>
</head>
<body>
    <div class="bg-container">
        <div class="main-wrapper">
            
                <a href="${pageContext.request.contextPath}/login" title="Ir a Inicio" style="display: inline-block;">
                    <img src="${pageContext.request.contextPath}/assets/images/logouts.png" alt="Logo UTS" class="logo">
                </a>
                <h2>¡Lo hacemos posible!</h2>
                <div class="tag-green">• PLATAFORMA FINANCIERA</div>
                
                <h1>Únete a la<br>Simulación<br>Educativa</h1>
                
                <p>Regístrate y comienza a administrar tus movimientos y recompensas institucionales de inmediato.</p>
                
                <div class="feature-tags">
                    <div class="feature-tag">Historial DUTS</div>
                    <div class="feature-tag">Transferencias</div>
                    <div class="feature-tag">Acceso 24/7</div>
                </div>
            </div>

            <div class="login-card">
                <h3>Crea tu cuenta</h3>
                <p class="subtitle">Estudiantes y docentes de las UTS</p>

                <div style="background: #f0fdf4; border: 1px solid #bbf7d0; color: #166534; padding: 10px 14px; border-radius: 8px; font-size: 12px; font-weight: 600; margin-bottom: 18px; display: flex; align-items: center; gap: 8px;">
                    <span style="background: #2f5c35; color: white; padding: 3px 8px; border-radius: 4px; font-size: 11px; font-weight: 800;">+500 DUTS</span>
                    <span>Bono institucional acreditado al registrarte por primera vez.</span>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert-error"><c:out value="${error}" /></div>
                </c:if>

                <form action="${pageContext.request.contextPath}/registro" method="POST" class="auth-form">
                    
                    <div class="input-half">
                        <label for="nombre_completo">Nombre Completo</label>
                        <input type="text" id="nombre_completo" name="nombre_completo" required placeholder="Nombres y Apellidos" value="<c:out value='${param.nombre_completo}'/>">
                    </div>

                    <div class="input-half">
                        <label for="codigo_estudiantil">Código Estudiantil</label>
                        <input type="text" id="codigo_estudiantil" name="codigo_estudiantil" required placeholder="Ej: 1005... o T000..." value="<c:out value='${param.codigo_estudiantil}'/>">
                    </div>
                    
                    <div class="input-half">
                        <label for="username">Nombre de Usuario (Login)</label>
                        <input type="text" id="username" name="username" required placeholder="Tu usuario" value="<c:out value='${param.username}'/>">
                    </div>

                    <div class="input-half">
                        <label for="correo">Correo (Institucional)</label>
                        <input type="email" id="correo" name="correo" required placeholder="ejemplo@correo.uts.edu.co" value="<c:out value='${param.correo}'/>">
                    </div>

                    <div class="input-half">
                        <label for="programa_academico">Programa Académico</label>
                        <select id="programa_academico" name="programa_academico" required style="width: 100%; padding: 12px; border: 1px solid #ccc; border-radius: 6px; font-size: 13px; margin-bottom: 15px; outline: none;">
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

                    <div class="input-half">
                        <label for="semestre">Semestre</label>
                        <input type="number" id="semestre" name="semestre" required min="1" max="10" placeholder="Ej. 1" value="<c:out value='${param.semestre}'/>">
                    </div>
                    
                    <div class="input-half">
                        <label for="clave">Contraseña</label>
                        <input type="password" id="clave" name="clave" required placeholder="Crea una clave">
                    </div>

                    <div class="input-half">
                        <label for="confirmar_clave">Confirmar Contraseña</label>
                        <input type="password" id="confirmar_clave" name="confirmar_clave" required placeholder="Repítela">
                    </div>
                    
                    <div class="input-group">
                        <button type="submit" class="btn-submit">Registrarse</button>
                    </div>
                </form>

                <a href="${pageContext.request.contextPath}/login" class="guest-link">¿Ya tienes cuenta? Ingresa aquí</a>
                <div class="help-text">Ayuda: duts@correo.uts.edu.co</div>
            </div>

        </div>
    </div>
</body>
</html>
