package co.edu.uts.duts.dao;

import co.edu.uts.duts.util.DatabaseConnection;
import org.mindrot.jbcrypt.BCrypt;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Base64;
import java.util.HexFormat;

/**
 * PasswordResetDAO: gestiona los tokens de un solo uso para restablecer contrasenas.
 * En la base de datos solo se guarda el hash SHA-256 del token; el token en claro
 * unicamente viaja en el enlace enviado al correo registrado del usuario.
 */
public class PasswordResetDAO {

    private static final Logger log = LoggerFactory.getLogger(PasswordResetDAO.class);
    private static final SecureRandom secureRandom = new SecureRandom();

    /** Datos minimos del titular de la cuenta necesarios para enviar el correo. */
    public static class Titular {
        public final int usuarioId;
        public final String nombre;
        public final String correo;

        Titular(int usuarioId, String nombre, String correo) {
            this.usuarioId = usuarioId;
            this.nombre = nombre;
            this.correo = correo;
        }
    }

    /** Busca al usuario cuyo usuario/codigo y correo coinciden. Devuelve null si no hay coincidencia. */
    public Titular buscarTitular(String usernameOrCodigo, String correo) {
        String sql = "SELECT id, nombre_completo, correo FROM usuarios " +
                     "WHERE (LOWER(username) = LOWER(?) OR LOWER(codigo_estudiantil) = LOWER(?)) AND LOWER(correo) = LOWER(?)";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, usernameOrCodigo.trim());
            ps.setString(2, usernameOrCodigo.trim());
            ps.setString(3, correo.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Titular(rs.getInt("id"), rs.getString("nombre_completo"), rs.getString("correo"));
                }
            }
        } catch (SQLException e) {
            log.error("Error al buscar titular para recuperacion de clave: {}", e.getMessage(), e);
        }
        return null;
    }

    /**
     * Crea un token nuevo para el usuario, invalidando los anteriores que sigan pendientes.
     * Devuelve el token en claro (para el enlace) o null si fallo.
     */
    public String crearToken(int usuarioId, int minutosValidez) {
        byte[] bytes = new byte[32];
        secureRandom.nextBytes(bytes);
        String token = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);

        String sqlInvalidar = "UPDATE password_reset_tokens SET usado = 1 WHERE usuario_id = ? AND usado = 0";
        String sqlInsertar = "INSERT INTO password_reset_tokens (usuario_id, token_hash, expira_en) " +
                             "VALUES (?, ?, DATE_ADD(NOW(), INTERVAL ? MINUTE))";
        Connection con = null;
        try {
            con = DatabaseConnection.getConnection();
            con.setAutoCommit(false);
            try (PreparedStatement ps = con.prepareStatement(sqlInvalidar)) {
                ps.setInt(1, usuarioId);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = con.prepareStatement(sqlInsertar)) {
                ps.setInt(1, usuarioId);
                ps.setString(2, hash(token));
                ps.setInt(3, minutosValidez);
                ps.executeUpdate();
            }
            con.commit();
            return token;
        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { log.error("Error en rollback: {}", ex.getMessage()); }
            }
            log.error("Error al crear token de recuperacion para usuario {}: {}", usuarioId, e.getMessage(), e);
            return null;
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); con.close(); } catch (SQLException e) { log.error("Error al cerrar conexion: {}", e.getMessage()); }
            }
        }
    }

    /** Indica si el token existe, no se ha usado y no ha expirado. */
    public boolean tokenValido(String token) {
        if (token == null || token.isEmpty()) return false;
        String sql = "SELECT 1 FROM password_reset_tokens WHERE token_hash = ? AND usado = 0 AND expira_en > NOW()";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, hash(token));
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            log.error("Error al validar token de recuperacion: {}", e.getMessage(), e);
            return false;
        }
    }

    /**
     * Consume el token y cambia la contrasena en una sola transaccion.
     * Devuelve false si el token no es valido, ya se uso o expiro.
     */
    public boolean restablecerConToken(String token, String nuevaPasswordPlana) {
        if (token == null || token.isEmpty() || nuevaPasswordPlana == null) return false;
        String tokenHash = hash(token);

        Connection con = null;
        try {
            con = DatabaseConnection.getConnection();
            con.setAutoCommit(false);

            int usuarioId = -1;
            String sqlToken = "SELECT usuario_id FROM password_reset_tokens " +
                              "WHERE token_hash = ? AND usado = 0 AND expira_en > NOW() FOR UPDATE";
            try (PreparedStatement ps = con.prepareStatement(sqlToken)) {
                ps.setString(1, tokenHash);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) usuarioId = rs.getInt("usuario_id");
                }
            }
            if (usuarioId == -1) {
                con.rollback();
                return false;
            }

            try (PreparedStatement ps = con.prepareStatement("UPDATE usuarios SET password_hash = ? WHERE id = ?")) {
                ps.setString(1, BCrypt.hashpw(nuevaPasswordPlana, BCrypt.gensalt(12)));
                ps.setInt(2, usuarioId);
                ps.executeUpdate();
            }
            // Marca como usados este token y cualquier otro pendiente del mismo usuario.
            try (PreparedStatement ps = con.prepareStatement(
                    "UPDATE password_reset_tokens SET usado = 1 WHERE usuario_id = ? AND usado = 0")) {
                ps.setInt(1, usuarioId);
                ps.executeUpdate();
            }

            con.commit();
            log.info("Contrasena restablecida mediante token para usuario ID {}", usuarioId);
            return true;
        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { log.error("Error en rollback: {}", ex.getMessage()); }
            }
            log.error("Error al restablecer contrasena con token: {}", e.getMessage(), e);
            return false;
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); con.close(); } catch (SQLException e) { log.error("Error al cerrar conexion: {}", e.getMessage()); }
            }
        }
    }

    private static String hash(String token) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            return HexFormat.of().formatHex(md.digest(token.getBytes(StandardCharsets.UTF_8)));
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException("SHA-256 no disponible", e);
        }
    }
}
