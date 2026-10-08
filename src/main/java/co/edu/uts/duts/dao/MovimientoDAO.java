package co.edu.uts.duts.dao;

import co.edu.uts.duts.model.Movimiento;
import co.edu.uts.duts.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MovimientoDAO {

    public List<Movimiento> listarPorUsuario(int usuarioId, int limite) {
        List<Movimiento> lista = new ArrayList<>();
        String sql = "SELECT m.* FROM movimientos_duts m " +
                     "INNER JOIN cuentas c ON m.cuenta_id = c.id " +
                     "WHERE c.usuario_id = ? " +
                     "ORDER BY m.fecha_hora DESC " +
                     (limite > 0 ? "LIMIT " + limite : "");

        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, usuarioId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Movimiento m = new Movimiento();
                    m.setId(rs.getInt("id"));
                    m.setCuentaId(rs.getInt("cuenta_id"));
                    m.setTipo(rs.getString("tipo"));
                    m.setMonto(rs.getDouble("monto"));
                    m.setDescripcion(rs.getString("descripcion"));
                    m.setReferencia(rs.getString("referencia"));
                    m.setFechaHora(rs.getTimestamp("fecha_hora"));
                    lista.add(m);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public Movimiento obtenerPorIdYUsuario(int movimientoId, int usuarioId) {
        String sql = "SELECT m.* FROM movimientos_duts m " +
                     "INNER JOIN cuentas c ON m.cuenta_id = c.id " +
                     "WHERE m.id = ? AND c.usuario_id = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, movimientoId);
            ps.setInt(2, usuarioId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Movimiento m = new Movimiento();
                    m.setId(rs.getInt("id"));
                    m.setCuentaId(rs.getInt("cuenta_id"));
                    m.setTipo(rs.getString("tipo"));
                    m.setMonto(rs.getDouble("monto"));
                    m.setDescripcion(rs.getString("descripcion"));
                    m.setReferencia(rs.getString("referencia"));
                    m.setFechaHora(rs.getTimestamp("fecha_hora"));
                    return m;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Movimiento> buscarPorUsuarioYFiltro(int usuarioId, String tipo, String busqueda) {
        List<Movimiento> lista = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT m.* FROM movimientos_duts m " +
            "INNER JOIN cuentas c ON m.cuenta_id = c.id " +
            "WHERE c.usuario_id = ? "
        );
        if (tipo != null && !tipo.trim().isEmpty() && !tipo.equalsIgnoreCase("TODOS")) {
            sql.append("AND m.tipo = ? ");
        }
        if (busqueda != null && !busqueda.trim().isEmpty()) {
            sql.append("AND (m.descripcion LIKE ? OR m.referencia LIKE ?) ");
        }
        sql.append("ORDER BY m.fecha_hora DESC");

        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            ps.setInt(paramIndex++, usuarioId);
            if (tipo != null && !tipo.trim().isEmpty() && !tipo.equalsIgnoreCase("TODOS")) {
                ps.setString(paramIndex++, tipo.trim().toUpperCase());
            }
            if (busqueda != null && !busqueda.trim().isEmpty()) {
                String pattern = "%" + busqueda.trim() + "%";
                ps.setString(paramIndex++, pattern);
                ps.setString(paramIndex++, pattern);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Movimiento m = new Movimiento();
                    m.setId(rs.getInt("id"));
                    m.setCuentaId(rs.getInt("cuenta_id"));
                    m.setTipo(rs.getString("tipo"));
                    m.setMonto(rs.getDouble("monto"));
                    m.setDescripcion(rs.getString("descripcion"));
                    m.setReferencia(rs.getString("referencia"));
                    m.setFechaHora(rs.getTimestamp("fecha_hora"));
                    lista.add(m);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    /**
     * Calcula los totales y promedios por semana, mes, semestre y año
     * según el requerimiento 2.3 del profesor.
     */
    public co.edu.uts.duts.model.MetricasDuts obtenerMetricasDuts(int usuarioId, double saldo, int semestre) {
        String sql = "SELECT " +
                     "COALESCE(SUM(CASE WHEN m.tipo = 'INGRESO' THEN m.monto ELSE 0 END), 0) AS total_ingresos, " +
                     "COALESCE(SUM(CASE WHEN m.tipo = 'EGRESO' THEN m.monto ELSE 0 END), 0) AS total_egresos " +
                     "FROM movimientos_duts m " +
                     "INNER JOIN cuentas c ON m.cuenta_id = c.id " +
                     "WHERE c.usuario_id = ?";

        double totalIngresos = 0.0;
        double totalEgresos = 0.0;

        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    totalIngresos = rs.getDouble("total_ingresos");
                    totalEgresos = rs.getDouble("total_egresos");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return co.edu.uts.duts.model.MetricasDuts.calcular(saldo, totalIngresos, totalEgresos, semestre);
    }
}
