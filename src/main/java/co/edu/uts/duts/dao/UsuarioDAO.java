package co.edu.uts.duts.dao;

import co.edu.uts.duts.model.Usuario;
import co.edu.uts.duts.util.DatabaseConnection;
import org.mindrot.jbcrypt.BCrypt;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    private static final Logger log = LoggerFactory.getLogger(UsuarioDAO.class);

    public Usuario autenticar(String usernameOrCorreo, String passwordPlana) {
        String sql = "SELECT * FROM usuarios WHERE username = ? OR correo = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, usernameOrCorreo);
            ps.setString(2, usernameOrCorreo);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String hashEnBd = rs.getString("password_hash");
                    if (BCrypt.checkpw(passwordPlana, hashEnBd)) {
                        return mapearUsuario(rs);
                    }
                }
            }
        } catch (SQLException e) {
            log.error("Error al autenticar usuario '{}': {}", usernameOrCorreo, e.getMessage(), e);
        }
        return null;
    }

    public Usuario obtenerPorId(int id) {
        String sql = "SELECT * FROM usuarios WHERE id = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearUsuario(rs);
                }
            }
        } catch (SQLException e) {
            log.error("Error al obtener usuario por ID {}: {}", id, e.getMessage(), e);
        }
        return null;
    }

    public boolean actualizarPerfil(int id, String nombreCompleto, String correo, String programaAcademico, int semestre) {
        String sql = "UPDATE usuarios SET nombre_completo = ?, correo = ?, programa_academico = ?, semestre = ? WHERE id = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nombreCompleto.trim());
            ps.setString(2, correo.trim());
            ps.setString(3, programaAcademico.trim());
            ps.setInt(4, semestre);
            ps.setInt(5, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            log.error("Error al actualizar perfil de usuario {}: {}", id, e.getMessage(), e);
        }
        return false;
    }

    public boolean registrarEstudiante(Usuario u, String passwordPlana) {
        String sqlUsuario = "INSERT INTO usuarios (codigo_estudiantil, nombre_completo, correo, username, password_hash, programa_academico, semestre, rol_id) VALUES (?, ?, ?, ?, ?, ?, ?, 1)";
        String sqlCuenta = "INSERT INTO cuentas (usuario_id, saldo) VALUES (?, 500.00)";
        String sqlMovimiento = "INSERT INTO movimientos_duts (cuenta_id, tipo, monto, descripcion, referencia) VALUES (?, 'INGRESO', 500.00, 'Bono de Bienvenida por Primera Inscripción DUTS', ?)";

        Connection con = null;
        try {
            con = DatabaseConnection.getConnection();
            con.setAutoCommit(false);

            String hash = BCrypt.hashpw(passwordPlana, BCrypt.gensalt(12));

            // 1. Insertar usuario
            int userId = -1;
            try (PreparedStatement psUser = con.prepareStatement(sqlUsuario, Statement.RETURN_GENERATED_KEYS)) {
                psUser.setString(1, u.getCodigoEstudiantil());
                psUser.setString(2, u.getNombreCompleto());
                psUser.setString(3, u.getCorreo());
                psUser.setString(4, u.getUsername());
                psUser.setString(5, hash);
                psUser.setString(6, u.getProgramaAcademico());
                psUser.setInt(7, u.getSemestre());

                int rows = psUser.executeUpdate();
                if (rows <= 0) {
                    con.rollback();
                    return false;
                }
                try (ResultSet rs = psUser.getGeneratedKeys()) {
                    if (rs.next()) {
                        userId = rs.getInt(1);
                    }
                }
            }

            if (userId == -1) {
                con.rollback();
                return false;
            }

            // 2. Crear cuenta con bono de 500 DUTS
            int cuentaId = -1;
            try (PreparedStatement psCuenta = con.prepareStatement(sqlCuenta, Statement.RETURN_GENERATED_KEYS)) {
                psCuenta.setInt(1, userId);
                psCuenta.executeUpdate();
                try (ResultSet rsC = psCuenta.getGeneratedKeys()) {
                    if (rsC.next()) {
                        cuentaId = rsC.getInt(1);
                    }
                }
            }

            // 3. Registrar movimiento inicial de auditoría
            if (cuentaId != -1) {
                try (PreparedStatement psMov = con.prepareStatement(sqlMovimiento)) {
                    psMov.setInt(1, cuentaId);
                    psMov.setString(2, "BONO-BIENVENIDA-" + System.currentTimeMillis());
                    psMov.executeUpdate();
                }
            }

            con.commit();
            return true;
        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { log.error("Error en rollback: {}", ex.getMessage()); }
            }
            log.error("Error al registrar estudiante '{}': {}", u.getUsername(), e.getMessage(), e);
            return false;
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); con.close(); } catch (SQLException e) { log.error("Error al cerrar conexión: {}", e.getMessage()); }
            }
        }
    }

    public boolean actualizarFotoPerfil(int id, String fotoPerfil) {
        String sql = "UPDATE usuarios SET foto_perfil = ? WHERE id = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, fotoPerfil.trim());
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            log.error("Error al actualizar foto de perfil para usuario {}: {}", id, e.getMessage(), e);
        }
        return false;
    }

    public List<Usuario> listarDestinatarios(int excludeUserId) {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuarios WHERE id != ? ORDER BY nombre_completo ASC";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, excludeUserId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearUsuario(rs));
                }
            }
        } catch (SQLException e) {
            log.error("Error al listar destinatarios: {}", e.getMessage(), e);
        }
        return lista;
    }

    public List<Usuario> buscarDestinatarios(int excludeUserId, String query) {
        if (query == null || query.trim().isEmpty()) {
            return listarDestinatarios(excludeUserId);
        }
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuarios WHERE id != ? AND (nombre_completo LIKE ? OR codigo_estudiantil LIKE ? OR username LIKE ? OR programa_academico LIKE ?) ORDER BY nombre_completo ASC";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, excludeUserId);
            String pattern = "%" + query.trim() + "%";
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            ps.setString(4, pattern);
            ps.setString(5, pattern);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearUsuario(rs));
                }
            }
        } catch (SQLException e) {
            log.error("Error al buscar destinatarios con query '{}': {}", query, e.getMessage(), e);
        }
        return lista;
    }

    public Usuario obtenerPorUsernameOCodigo(String identificador) {
        if (identificador == null || identificador.trim().isEmpty()) {
            return null;
        }
        String sql = "SELECT * FROM usuarios WHERE codigo_estudiantil = ? OR username = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, identificador.trim());
            ps.setString(2, identificador.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearUsuario(rs);
                }
            }
        } catch (SQLException e) {
            log.error("Error al obtener usuario por identificador '{}': {}", identificador, e.getMessage(), e);
        }
        return null;
    }

    /**
     * Restablece la contraseña de un usuario si su identificador (código o username)
     * y su correo institucional registrado coinciden en el sistema.
     * Genera un nuevo hash BCrypt y actualiza la base de datos de forma segura.
     */
    public boolean restablecerPassword(String usernameOrCodigo, String correo, String nuevaPasswordPlana) {
        if (usernameOrCodigo == null || correo == null || nuevaPasswordPlana == null || nuevaPasswordPlana.length() < 6) {
            return false;
        }
        String sql = "UPDATE usuarios SET password_hash = ? WHERE (LOWER(username) = LOWER(?) OR LOWER(codigo_estudiantil) = LOWER(?)) AND LOWER(correo) = LOWER(?)";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            String nuevoHash = BCrypt.hashpw(nuevaPasswordPlana, BCrypt.gensalt(12));
            ps.setString(1, nuevoHash);
            ps.setString(2, usernameOrCodigo.trim());
            ps.setString(3, usernameOrCodigo.trim());
            ps.setString(4, correo.trim());
            int filas = ps.executeUpdate();
            if (filas > 0) {
                log.info("Contraseña restablecida exitosamente para identificador '{}' y correo '{}'", usernameOrCodigo, correo);
                return true;
            }
        } catch (SQLException e) {
            log.error("Error al restablecer contraseña para '{}': {}", usernameOrCodigo, e.getMessage(), e);
        }
        return false;
    }

    private Usuario mapearUsuario(ResultSet rs) throws SQLException {
        Usuario u = new Usuario();
        u.setId(rs.getInt("id"));
        u.setCodigoEstudiantil(rs.getString("codigo_estudiantil"));
        u.setNombreCompleto(rs.getString("nombre_completo"));
        u.setCorreo(rs.getString("correo"));
        u.setUsername(rs.getString("username"));
        u.setProgramaAcademico(rs.getString("programa_academico"));
        u.setSemestre(rs.getInt("semestre"));
        u.setRolId(rs.getInt("rol_id"));
        
        Timestamp fechaReg = null;
        try {
            fechaReg = rs.getTimestamp("fecha_registro");
        } catch (SQLException e) {
            try {
                fechaReg = rs.getTimestamp("creado_en");
            } catch (SQLException ignored) {}
        }
        u.setFechaRegistro(fechaReg);

        try {
            u.setFotoPerfil(rs.getString("foto_perfil"));
        } catch (SQLException ignored) {}
        return u;
    }
}
