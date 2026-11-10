package co.edu.uts.duts.dao;

import co.edu.uts.duts.util.DatabaseConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CuentaDAO {

    private static final Logger log = LoggerFactory.getLogger(CuentaDAO.class);

    // Obtener el saldo de un usuario por su ID
    public double obtenerSaldoPorUsuarioId(int usuarioId) {
        String sql = "SELECT saldo FROM cuentas WHERE usuario_id = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, usuarioId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("saldo");
                }
            }
        } catch (SQLException e) {
            log.error("Error al obtener saldo para el usuario {}: {}", usuarioId, e.getMessage(), e);
        }
        return 0.00; // Si no hay cuenta, asumimos 0
    }
}
