-- ==========================================================
-- SISTEMA UTS DUTS: SCRIPT DE BASE DE DATOS COMPLETO
-- Ecosistema de Méritos y Vida Universitaria UTS
-- Motor: MySQL 8.0 (InnoDB) - Soporta UTF8MB4
-- ==========================================================

CREATE DATABASE IF NOT EXISTS duts CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE duts;

-- 1. TABLA: usuarios
DROP TABLE IF EXISTS inscripciones_eventos;
DROP TABLE IF EXISTS transferencias;
DROP TABLE IF EXISTS movimientos_duts;
DROP TABLE IF EXISTS cuentas;
DROP TABLE IF EXISTS eventos;
DROP TABLE IF EXISTS usuarios;

CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo_estudiantil VARCHAR(20) NOT NULL UNIQUE,
    nombre_completo VARCHAR(100) NOT NULL,
    correo VARCHAR(100) NOT NULL UNIQUE,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    programa_academico VARCHAR(100) DEFAULT 'Ingeniería de Sistemas',
    semestre INT DEFAULT 1,
    rol_id INT NOT NULL DEFAULT 1 COMMENT '1: Estudiante, 2: Administrador',
    foto_perfil VARCHAR(255) DEFAULT 'default-avatar.svg',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 2. TABLA: cuentas (Relación 1 a 1 con usuarios)
CREATE TABLE cuentas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL UNIQUE,
    saldo DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_cuentas_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 3. TABLA: movimientos_duts (Libro Mayor de Transacciones)
CREATE TABLE movimientos_duts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cuenta_id INT NOT NULL,
    tipo ENUM('INGRESO', 'EGRESO') NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    referencia VARCHAR(100) NOT NULL UNIQUE,
    fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_movimientos_cuenta FOREIGN KEY (cuenta_id) REFERENCES cuentas(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 4. TABLA: transferencias (Operaciones P2P entre Cuentas)
CREATE TABLE transferencias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    movimiento_origen_id INT NOT NULL,
    movimiento_destino_id INT NOT NULL,
    concepto VARCHAR(255) DEFAULT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_transf_origen FOREIGN KEY (movimiento_origen_id) REFERENCES movimientos_duts(id) ON DELETE CASCADE,
    CONSTRAINT fk_transf_destino FOREIGN KEY (movimiento_destino_id) REFERENCES movimientos_duts(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 5. TABLA: eventos (Catálogo de Eventos con Méritos DUTS)
CREATE TABLE eventos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    fecha DATETIME NOT NULL,
    hora_inicio VARCHAR(10) DEFAULT '08:00 AM',
    hora_fin VARCHAR(10) DEFAULT '12:00 PM',
    lugar VARCHAR(150) NOT NULL,
    direccion VARCHAR(150) DEFAULT 'Calle de los Estudiantes # 9-82, Real de Minas',
    universidad VARCHAR(50) NOT NULL DEFAULT 'UTS (uts.edu.co)',
    categoria VARCHAR(50) NOT NULL DEFAULT 'TECNOLOGÍA',
    recompensa_duts DOUBLE NOT NULL DEFAULT 500.0,
    cupos INT NOT NULL DEFAULT 50,
    modalidad VARCHAR(30) DEFAULT 'Presencial',
    requisitos TEXT,
    imagen_url VARCHAR(255) DEFAULT 'assets/images/evento_tecnologia.jpg',
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
) ENGINE=InnoDB;

-- 6. TABLA: inscripciones_eventos (Control de Asistencia)
CREATE TABLE inscripciones_eventos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    evento_id INT NOT NULL,
    estado ENUM('INSCRITO', 'ASISTIO', 'RECOMPENSADO', 'CANCELADO') NOT NULL DEFAULT 'INSCRITO',
    fecha_inscripcion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_inscrip_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    CONSTRAINT fk_inscrip_evento FOREIGN KEY (evento_id) REFERENCES eventos(id) ON DELETE CASCADE,
    CONSTRAINT uq_usuario_evento UNIQUE (usuario_id, evento_id)
) ENGINE=InnoDB;

-- ==========================================================
-- ÍNDICES ESTRATÉGICOS DE RENDIMIENTO PARA PRODUCCIÓN
-- Optimizan las consultas más frecuentes de balance, historial y filtros
-- ==========================================================
CREATE INDEX idx_movimientos_cuenta_fecha ON movimientos_duts(cuenta_id, fecha_hora DESC);
CREATE INDEX idx_eventos_estado_fecha ON eventos(estado, fecha ASC);
CREATE INDEX idx_eventos_categoria ON eventos(categoria);
CREATE INDEX idx_inscripciones_user_estado ON inscripciones_eventos(usuario_id, estado);
CREATE INDEX idx_transferencias_fecha ON transferencias(fecha DESC);

-- ==========================================================
-- DATOS INICIALES (SEMILLA) PARA PRUEBAS INMEDIATAS
-- Contraseñas con hash BCrypt:
--   admin -> 'admin123'
--   estudiante -> 'estudiante123'
-- ==========================================================

INSERT INTO usuarios (id, codigo_estudiantil, nombre_completo, correo, username, password_hash, programa_academico, semestre, rol_id, foto_perfil) VALUES
(1, 'ADM-001', 'Administrador General UTS', 'admin@correo.uts.edu.co', 'admin', '$2a$12$lRBNzzeBThH7NiVWAaBWR..k1qF1UGEpOxZ8ZHBMBEtLYtSzP33Ae', 'Dirección de TI y Sistemas', 10, 2, 'default-avatar.svg'),
(2, '1098765432', 'Estudiante Uteísta', 'estudiante@correo.uts.edu.co', 'estudiante', '$2a$12$8TXc6VtB/MeL6LsTB4wtTeep/tRKNeFGRismqhuTe8FyuP60i1NsC', 'Ingeniería de Sistemas', 6, 1, 'default-avatar.svg'),
(3, '1098888777', 'María Paula Gómez', 'mp.gomez@correo.uts.edu.co', 'mariapaula', '$2a$12$8TXc6VtB/MeL6LsTB4wtTeep/tRKNeFGRismqhuTe8FyuP60i1NsC', 'Tecnología en Desarrollo de Software', 4, 1, 'default-avatar.svg');

-- Cuentas de los usuarios iniciales
INSERT INTO cuentas (id, usuario_id, saldo) VALUES
(1, 1, 100000.00),
(2, 2, 8500.00),
(3, 3, 4200.00);

-- Movimientos iniciales para libro mayor y extractos
INSERT INTO movimientos_duts (id, cuenta_id, tipo, monto, descripcion, referencia, fecha_hora) VALUES
(1, 1, 'INGRESO', 100000.00, 'Fondo Institucional de Méritos DUTS UTS', 'INIT-FND-001', NOW() - INTERVAL 10 DAY),
(2, 2, 'INGRESO', 500.00, 'Bono de Bienvenida por Primera Inscripción DUTS', 'BONO-BIENVENIDA-1098765432', NOW() - INTERVAL 8 DAY),
(3, 2, 'INGRESO', 4000.00, 'Recompensa por Participación en Congreso de Robótica', 'REC-EVT-001-9871', NOW() - INTERVAL 5 DAY),
(4, 2, 'INGRESO', 4000.00, 'Recompensa por Asistencia al Taller de Ciberseguridad', 'REC-EVT-002-3412', NOW() - INTERVAL 2 DAY),
(5, 3, 'INGRESO', 500.00, 'Bono de Bienvenida por Primera Inscripción DUTS', 'BONO-BIENVENIDA-1098888777', NOW() - INTERVAL 7 DAY),
(6, 3, 'INGRESO', 3700.00, 'Recompensa por Ponencia en Semillero de Innovación', 'REC-EVT-003-8812', NOW() - INTERVAL 3 DAY);

-- Eventos académicos oficiales de la Red Universitaria
INSERT INTO eventos (id, nombre, descripcion, fecha, hora_inicio, hora_fin, lugar, direccion, universidad, categoria, recompensa_duts, cupos, modalidad, requisitos, imagen_url, estado) VALUES
(1, 'Congreso Internacional de Robótica e IA 2026', 'Magno encuentro académico con ponencias internacionales sobre inteligencia artificial aplicada a la automatización industrial.', '2026-11-20 08:30:00', '08:30 AM', '01:00 PM', 'Auditorio Mayor Edificio A, UTS', 'Calle de los Estudiantes # 9-82, Real de Minas', 'UTS (uts.edu.co)', 'TECNOLOGÍA', 2500.0, 150, 'Presencial', 'Carné de estudiante vigente o documento de identidad institucional.', 'assets/images/evento_robotica.jpg', 'ACTIVO'),
(2, 'Olimpiadas Universitarias de Programación ASCUN', 'Competencia de algoritmos y resolución de retos de desarrollo de software interuniversitario Nodo Santander.', '2026-11-25 09:00:00', '09:00 AM', '04:00 PM', 'Laboratorio de Cómputo B-204, UTS', 'Campus Principal Calle de los Estudiantes, Bucaramanga', 'UTS (uts.edu.co)', 'TECNOLOGÍA', 3500.0, 60, 'Presencial', 'Inscripción previa en equipos de 3 estudiantes.', 'assets/images/evento_tecnologia.jpg', 'ACTIVO'),
(3, 'Seminario de Emprendimiento Tecnológico Uteísta', 'Taller práctico de ideación de startups, modelos de negocio fintech y monetización de proyectos tecnológicos.', '2026-11-28 14:00:00', '02:00 PM', '06:00 PM', 'Centro de Convenciones Neomundo', 'Calle 89 Transversal Oriental, Bucaramanga', 'UTS (uts.edu.co)', 'EMPRENDIMIENTO', 1800.0, 200, 'Presencial', 'Abierto a todos los semestres de facultades socioeconómicas e ingeniería.', 'assets/images/evento_emprendimiento.jpg', 'ACTIVO'),
(4, 'Torneo Interfacultades de Fútbol Sala UTS', 'Campeonato deportivo institucional por la integración y bienestar estudiantil de Santander.', '2026-12-02 10:00:00', '10:00 AM', '01:00 PM', 'Coliseo Deportivo Edificio C, UTS', 'Real de Minas, Bucaramanga', 'UTS (uts.edu.co)', 'DEPORTES', 1200.0, 80, 'Presencial', 'Uniforme institucional de educación física o camiseta del programa.', 'assets/images/evento_deportes.jpg', 'ACTIVO'),
(5, 'Conferencia Red Santander: Ciberseguridad Bancaria', 'Encuentro con especialistas de la banca nacional y el nodo universitario ASCUN Santander sobre prevención de fraudes.', '2026-12-05 15:00:00', '03:00 PM', '07:00 PM', 'Auditorio Luis A. Calvo (UIS) / Streaming UTS', 'Ciudad Universitaria UIS Carrera 27 Calle 9, Bucaramanga', 'UIS (uis.edu.co)', 'CONFERENCIA', 2000.0, 300, 'Híbrida', 'Conexión a través del portal institucional o asistencia con carné.', 'assets/images/evento_conferencia.jpg', 'ACTIVO');

-- Inscripción de prueba
INSERT INTO inscripciones_eventos (usuario_id, evento_id, estado) VALUES
(2, 1, 'INSCRITO');
