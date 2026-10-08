package co.edu.uts.duts.dao;

import co.edu.uts.duts.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TransferenciaDAO {

    public static class ResultadoTransferencia {
        private boolean exitoso;
        private String mensaje;

        public ResultadoTransferencia(boolean exitoso, String mensaje) {
            this.exitoso = exitoso;
            this.mensaje = mensaje;
        }
        public boolean isExitoso() { return exitoso; }
        public String getMensaje() { return mensaje; }
    }

    // Realizar transferencia entre dos cuentas
    public ResultadoTransferencia transferirDuts(int usuarioOrigenId, String identificadorDestino, double monto, String concepto) {
        if (monto <= 0) {
            return new ResultadoTransferencia(false, "El monto a transferir debe ser mayor a 0 DUTS.");
        }

        Connection con = null;
        try {
            con = DatabaseConnection.getConnection();
            con.setAutoCommit(false);

            // 1. Obtener usuario de origen y cuenta
            int cuentaOrigenId = -1;
            double saldoOrigen = 0.0;
            String sqlCuentaOrigen = "SELECT id, saldo FROM cuentas WHERE usuario_id = ?";
            try (PreparedStatement ps = con.prepareStatement(sqlCuentaOrigen)) {
                ps.setInt(1, usuarioOrigenId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        cuentaOrigenId = rs.getInt("id");
                        saldoOrigen = rs.getDouble("saldo");
                    }
                }
            }

            if (cuentaOrigenId == -1) {
                con.rollback();
                return new ResultadoTransferencia(false, "No se encontró la cuenta de origen.");
            }

            if (saldoOrigen < monto) {
                con.rollback();
                return new ResultadoTransferencia(false, "Saldo insuficiente. Tu saldo actual es " + saldoOrigen + " DUTS.");
            }

            // 2. Buscar usuario destino por código estudiantil o username
            int usuarioDestinoId = -1;
            String nombreDestino = "";
            String sqlUserDestino = "SELECT id, nombre_completo FROM usuarios WHERE (codigo_estudiantil = ? OR username = ?)";
            try (PreparedStatement ps = con.prepareStatement(sqlUserDestino)) {
                ps.setString(1, identificadorDestino.trim());
                ps.setString(2, identificadorDestino.trim());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        usuarioDestinoId = rs.getInt("id");
                        nombreDestino = rs.getString("nombre_completo");
                    }
                }
            }

            if (usuarioDestinoId == -1) {
                con.rollback();
                return new ResultadoTransferencia(false, "Destinatario no encontrado. Verifica el código estudiantil o usuario.");
            }

            if (usuarioDestinoId == usuarioOrigenId) {
                con.rollback();
                return new ResultadoTransferencia(false, "No puedes transferirte DUTS a ti mismo.");
            }

            // 3. Buscar cuenta destino (si no existe, crearla)
            int cuentaDestinoId = -1;
            String sqlCuentaDestino = "SELECT id FROM cuentas WHERE usuario_id = ?";
            try (PreparedStatement ps = con.prepareStatement(sqlCuentaDestino)) {
                ps.setInt(1, usuarioDestinoId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        cuentaDestinoId = rs.getInt("id");
                    }
                }
            }

            if (cuentaDestinoId == -1) {
                String sqlCrearCuenta = "INSERT INTO cuentas (usuario_id, saldo) VALUES (?, 0.00)";
                try (PreparedStatement ps = con.prepareStatement(sqlCrearCuenta, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, usuarioDestinoId);
                    ps.executeUpdate();
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            cuentaDestinoId = rs.getInt(1);
                        }
                    }
                }
            }

            // 4. Descontar saldo al origen
            String sqlDebitar = "UPDATE cuentas SET saldo = saldo - ? WHERE id = ?";
            try (PreparedStatement ps = con.prepareStatement(sqlDebitar)) {
                ps.setDouble(1, monto);
                ps.setInt(2, cuentaOrigenId);
                ps.executeUpdate();
            }

            // 5. Abonar saldo al destino
            String sqlAcreditar = "UPDATE cuentas SET saldo = saldo + ? WHERE id = ?";
            try (PreparedStatement ps = con.prepareStatement(sqlAcreditar)) {
                ps.setDouble(1, monto);
                ps.setInt(2, cuentaDestinoId);
                ps.executeUpdate();
            }

            long timestamp = System.currentTimeMillis();
            String refOrigen = "TRF-OUT-" + timestamp;
            String refDestino = "TRF-IN-" + timestamp;

            // 6. Registrar movimiento EGRESO para origen
            int movOrigenId = -1;
            String sqlMovOrigen = "INSERT INTO movimientos_duts (cuenta_id, tipo, monto, descripcion, referencia) VALUES (?, 'EGRESO', ?, ?, ?)";
            try (PreparedStatement ps = con.prepareStatement(sqlMovOrigen, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, cuentaOrigenId);
                ps.setDouble(2, monto);
                ps.setString(3, "Envío a " + nombreDestino + (concepto != null && !concepto.trim().isEmpty() ? " - " + concepto.trim() : ""));
                ps.setString(4, refOrigen);
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) movOrigenId = rs.getInt(1);
                }
            }

            // 7. Registrar movimiento INGRESO para destino
            int movDestinoId = -1;
            String sqlMovDestino = "INSERT INTO movimientos_duts (cuenta_id, tipo, monto, descripcion, referencia) VALUES (?, 'INGRESO', ?, ?, ?)";
            try (PreparedStatement ps = con.prepareStatement(sqlMovDestino, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, cuentaDestinoId);
                ps.setDouble(2, monto);
                ps.setString(3, "Recepción de transferencia" + (concepto != null && !concepto.trim().isEmpty() ? " - " + concepto.trim() : ""));
                ps.setString(4, refDestino);
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) movDestinoId = rs.getInt(1);
                }
            }

            // 8. Registrar en tabla de transferencias
            String sqlTrf = "INSERT INTO transferencias (movimiento_origen_id, movimiento_destino_id, concepto) VALUES (?, ?, ?)";
            try (PreparedStatement ps = con.prepareStatement(sqlTrf)) {
                ps.setInt(1, movOrigenId);
                ps.setInt(2, movDestinoId);
                ps.setString(3, concepto != null ? concepto.trim() : "Transferencia DUTS");
                ps.executeUpdate();
            }

            con.commit();
            return new ResultadoTransferencia(true, "Transferencia de " + monto + " DUTS a " + nombreDestino + " realizada con éxito.");

        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return new ResultadoTransferencia(false, "Error interno en la base de datos al realizar la transferencia.");
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); con.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }

    // Recargar saldo (simulación pedagógica)
    public ResultadoTransferencia recargarSaldoSimulado(int usuarioId, double monto) {
        if (monto <= 0) return new ResultadoTransferencia(false, "Monto inválido");

        Connection con = null;
        try {
            con = DatabaseConnection.getConnection();
            con.setAutoCommit(false);

            int cuentaId = -1;
            String sqlCuenta = "SELECT id FROM cuentas WHERE usuario_id = ?";
            try (PreparedStatement ps = con.prepareStatement(sqlCuenta)) {
                ps.setInt(1, usuarioId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) cuentaId = rs.getInt("id");
                }
            }

            if (cuentaId == -1) {
                String sqlCrear = "INSERT INTO cuentas (usuario_id, saldo) VALUES (?, 0.00)";
                try (PreparedStatement ps = con.prepareStatement(sqlCrear, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, usuarioId);
                    ps.executeUpdate();
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) cuentaId = rs.getInt(1);
                    }
                }
            }

            String sqlUpdate = "UPDATE cuentas SET saldo = saldo + ? WHERE id = ?";
            try (PreparedStatement ps = con.prepareStatement(sqlUpdate)) {
                ps.setDouble(1, monto);
                ps.setInt(2, cuentaId);
                ps.executeUpdate();
            }

            String sqlMov = "INSERT INTO movimientos_duts (cuenta_id, tipo, monto, descripcion, referencia) VALUES (?, 'INGRESO', ?, ?, ?)";
            try (PreparedStatement ps = con.prepareStatement(sqlMov)) {
                ps.setInt(1, cuentaId);
                ps.setDouble(2, monto);
                ps.setString(3, "Beca de Estímulo Académico DUTS");
                ps.setString(4, "SIM-RECHARGE-" + System.currentTimeMillis());
                ps.executeUpdate();
            }

            con.commit();
            return new ResultadoTransferencia(true, "Se han acreditado " + monto + " DUTS a tu cuenta.");
        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return new ResultadoTransferencia(false, "Error al recargar saldo.");
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); con.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }

    // Listar historial de transferencias enviadas y recibidas del usuario
    public List<Map<String, Object>> listarTransferenciasUsuario(int usuarioId) {
        List<Map<String, Object>> lista = new ArrayList<>();
        String sql = "SELECT t.id, t.concepto, " +
                     "mo.monto AS monto, mo.fecha_hora, mo.referencia AS ref_origen, " +
                     "uo.id AS usuario_origen_id, uo.nombre_completo AS nombre_origen, uo.codigo_estudiantil AS codigo_origen, " +
                     "ud.id AS usuario_destino_id, ud.nombre_completo AS nombre_destino, ud.codigo_estudiantil AS codigo_destino " +
                     "FROM transferencias t " +
                     "INNER JOIN movimientos_duts mo ON t.movimiento_origen_id = mo.id " +
                     "INNER JOIN cuentas co ON mo.cuenta_id = co.id " +
                     "INNER JOIN usuarios uo ON co.usuario_id = uo.id " +
                     "INNER JOIN movimientos_duts md ON t.movimiento_destino_id = md.id " +
                     "INNER JOIN cuentas cd ON md.cuenta_id = cd.id " +
                     "INNER JOIN usuarios ud ON cd.usuario_id = ud.id " +
                     "WHERE co.usuario_id = ? OR cd.usuario_id = ? " +
                     "ORDER BY mo.fecha_hora DESC LIMIT 20";

        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, usuarioId);
            ps.setInt(2, usuarioId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("id", rs.getInt("id"));
                    map.put("concepto", rs.getString("concepto"));
                    map.put("monto", rs.getDouble("monto"));
                    map.put("fechaHora", rs.getTimestamp("fecha_hora"));
                    map.put("esRemitente", rs.getInt("usuario_origen_id") == usuarioId);
                    map.put("nombreOrigen", rs.getString("nombre_origen"));
                    map.put("codigoOrigen", rs.getString("codigo_origen"));
                    map.put("nombreDestino", rs.getString("nombre_destino"));
                    map.put("codigoDestino", rs.getString("codigo_destino"));
                    lista.add(map);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}
