package co.edu.uts.duts.dao;

import co.edu.uts.duts.model.MetricasDuts;
import co.edu.uts.duts.model.Movimiento;
import co.edu.uts.duts.util.DatabaseConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MovimientoDAO {

    private static final Logger log = LoggerFactory.getLogger(MovimientoDAO.class);

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
                    lista.add(mapearMovimiento(rs));
                }
            }
        } catch (SQLException e) {
            log.error("Error al listar movimientos para usuario {}: {}", usuarioId, e.getMessage(), e);
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
                    return mapearMovimiento(rs);
                }
            }
        } catch (SQLException e) {
            log.error("Error al obtener movimiento {} para usuario {}: {}", movimientoId, usuarioId, e.getMessage(), e);
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
                    lista.add(mapearMovimiento(rs));
                }
            }
        } catch (SQLException e) {
            log.error("Error al filtrar movimientos para usuario {}: {}", usuarioId, e.getMessage(), e);
        }
        return lista;
    }

    /**
     * Calcula los totales y promedios por semana, mes, semestre y año
     * según el requerimiento 2.3 del profesor.
     */
    public MetricasDuts obtenerMetricasDuts(int usuarioId, double saldo, int semestre) {
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
            log.error("Error al calcular métricas DUTS para usuario {}: {}", usuarioId, e.getMessage(), e);
        }

        return MetricasDuts.calcular(saldo, totalIngresos, totalEgresos, semestre);
    }

    private Movimiento mapearMovimiento(ResultSet rs) throws SQLException {
        Movimiento m = new Movimiento();
        m.setId(rs.getInt("id"));
        m.setCuentaId(rs.getInt("cuenta_id"));
        m.setTipo(rs.getString("tipo"));
        m.setMonto(rs.getDouble("monto"));
        m.setDescripcion(rs.getString("descripcion"));
        m.setReferencia(rs.getString("referencia"));
        
        Timestamp fh = null;
        try {
            fh = rs.getTimestamp("fecha_hora");
        } catch (SQLException e) {
            try {
                fh = rs.getTimestamp("creado_en");
            } catch (SQLException ignored) {}
        }
        m.setFechaHora(fh);
        return m;
    }
}
