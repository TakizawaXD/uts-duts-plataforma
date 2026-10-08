package co.edu.uts.duts.dao;

import co.edu.uts.duts.util.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CuentaDAO {
    
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
            e.printStackTrace();
        }
        return 0.00; // Si no hay cuenta, asumimos 0
    }
}
