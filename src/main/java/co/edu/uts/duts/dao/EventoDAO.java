package co.edu.uts.duts.dao;

import co.edu.uts.duts.model.Evento;
import co.edu.uts.duts.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EventoDAO {

    // Listar eventos activos con el estado de inscripción del usuario
    public List<Evento> listarActivos(int usuarioId) {
        List<Evento> lista = new ArrayList<>();
        String sql = "SELECT e.*, (ie.id IS NOT NULL) AS esta_inscrito " +
                     "FROM eventos e " +
                     "LEFT JOIN inscripciones_eventos ie ON e.id = ie.evento_id AND ie.usuario_id = ? " +
                     "WHERE e.estado = 'ACTIVO' " +
                     "ORDER BY e.fecha ASC";
        
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, usuarioId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Evento ev = mapearEvento(rs);
                    ev.setInscrito(rs.getBoolean("esta_inscrito"));
                    lista.add(ev);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // Listar todos los eventos (CRUD Admin)
    public List<Evento> listarTodos() {
        List<Evento> lista = new ArrayList<>();
        String sql = "SELECT * FROM eventos ORDER BY id DESC";
        
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                lista.add(mapearEvento(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // Obtener evento por ID
    public Evento obtenerPorId(int id) {
        String sql = "SELECT * FROM eventos WHERE id = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearEvento(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Crear nuevo evento (CRUD Create)
    public boolean crear(Evento ev) {
        String sql = "INSERT INTO eventos (nombre, descripcion, fecha, lugar, categoria, recompensa_duts, cupos, estado, imagen_url, direccion, universidad) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, ev.getNombre());
            ps.setString(2, ev.getDescripcion());
            ps.setTimestamp(3, ev.getFecha());
            ps.setString(4, ev.getLugar());
            ps.setString(5, ev.getCategoria());
            ps.setDouble(6, ev.getRecompensaDuts());
            ps.setInt(7, ev.getCupos());
            ps.setString(8, ev.getEstado());
            ps.setString(9, ev.getImagenUrl());
            ps.setString(10, ev.getDireccion());
            ps.setString(11, ev.getUniversidad());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Actualizar evento existente (CRUD Update)
    public boolean actualizar(Evento ev) {
        String sql = "UPDATE eventos SET nombre = ?, descripcion = ?, fecha = ?, lugar = ?, " +
                     "categoria = ?, recompensa_duts = ?, cupos = ?, estado = ?, imagen_url = ?, direccion = ?, universidad = ? WHERE id = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, ev.getNombre());
            ps.setString(2, ev.getDescripcion());
            ps.setTimestamp(3, ev.getFecha());
            ps.setString(4, ev.getLugar());
            ps.setString(5, ev.getCategoria());
            ps.setDouble(6, ev.getRecompensaDuts());
            ps.setInt(7, ev.getCupos());
            ps.setString(8, ev.getEstado());
            ps.setString(9, ev.getImagenUrl());
            ps.setString(10, ev.getDireccion());
            ps.setString(11, ev.getUniversidad());
            ps.setInt(12, ev.getId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Eliminar evento (CRUD Delete)
    public boolean eliminar(int id) {
        String sqlDeleteInscripciones = "DELETE FROM inscripciones_eventos WHERE evento_id = ?";
        String sqlDeleteEvento = "DELETE FROM eventos WHERE id = ?";
        
        Connection con = null;
        try {
            con = DatabaseConnection.getConnection();
            con.setAutoCommit(false);
            
            try (PreparedStatement ps1 = con.prepareStatement(sqlDeleteInscripciones)) {
                ps1.setInt(1, id);
                ps1.executeUpdate();
            }
            
            try (PreparedStatement ps2 = con.prepareStatement(sqlDeleteEvento)) {
                ps2.setInt(1, id);
                int filas = ps2.executeUpdate();
                if (filas > 0) {
                    con.commit();
                    return true;
                }
            }
            con.rollback();
        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); con.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
        return false;
    }

    // Inscribir usuario al evento (acredita 500 DUTS de bono si es su primera inscripción)
    public boolean inscribirUsuario(int usuarioId, int eventoId) {
        String sqlCheckPrimera = "SELECT COUNT(*) FROM inscripciones_eventos WHERE usuario_id = ?";
        String sqlInsert = "INSERT INTO inscripciones_eventos (usuario_id, evento_id, estado) VALUES (?, ?, 'INSCRITO')";
        String sqlCuenta = "SELECT id FROM cuentas WHERE usuario_id = ?";
        String sqlUpdateSaldo = "UPDATE cuentas SET saldo = saldo + 500.00 WHERE id = ?";
        String sqlMov = "INSERT INTO movimientos_duts (cuenta_id, tipo, monto, descripcion, referencia) VALUES (?, 'INGRESO', 500.00, 'Bono de Estímulo por Primera Inscripción a Evento', ?)";

        Connection con = null;
        try {
            con = DatabaseConnection.getConnection();
            con.setAutoCommit(false);

            boolean esPrimeraInscripcion = false;
            try (PreparedStatement psCheck = con.prepareStatement(sqlCheckPrimera)) {
                psCheck.setInt(1, usuarioId);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next() && rs.getInt(1) == 0) {
                        esPrimeraInscripcion = true;
                    }
                }
            }

            try (PreparedStatement ps = con.prepareStatement(sqlInsert)) {
                ps.setInt(1, usuarioId);
                ps.setInt(2, eventoId);
                ps.executeUpdate();
            }

            if (esPrimeraInscripcion) {
                int cuentaId = -1;
                try (PreparedStatement psC = con.prepareStatement(sqlCuenta)) {
                    psC.setInt(1, usuarioId);
                    try (ResultSet rs = psC.executeQuery()) {
                        if (rs.next()) cuentaId = rs.getInt("id");
                    }
                }
                if (cuentaId != -1) {
                    try (PreparedStatement psUp = con.prepareStatement(sqlUpdateSaldo)) {
                        psUp.setInt(1, cuentaId);
                        psUp.executeUpdate();
                    }
                    try (PreparedStatement psMov = con.prepareStatement(sqlMov)) {
                        psMov.setInt(1, cuentaId);
                        psMov.setString(2, "BONO-PRIMER-EVENTO-" + System.currentTimeMillis());
                        psMov.executeUpdate();
                    }
                }
            }

            con.commit();
            return true;
        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); con.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }

    // Cancelar inscripción
    public boolean cancelarInscripcion(int usuarioId, int eventoId) {
        String sql = "DELETE FROM inscripciones_eventos WHERE usuario_id = ? AND evento_id = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, usuarioId);
            ps.setInt(2, eventoId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Reclamar recompensa de un evento (simulación para acreditar DUTS)
    public boolean reclamarRecompensa(int usuarioId, int eventoId) {
        Evento ev = obtenerPorId(eventoId);
        if (ev == null) return false;

        Connection con = null;
        try {
            con = DatabaseConnection.getConnection();
            con.setAutoCommit(false);

            // 1. Obtener id de cuenta del usuario
            int cuentaId = -1;
            String sqlCuenta = "SELECT id FROM cuentas WHERE usuario_id = ?";
            try (PreparedStatement ps = con.prepareStatement(sqlCuenta)) {
                ps.setInt(1, usuarioId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        cuentaId = rs.getInt("id");
                    }
                }
            }
            if (cuentaId == -1) {
                con.rollback();
                return false;
            }

            // 2. Incrementar saldo en cuenta
            String sqlUpdateSaldo = "UPDATE cuentas SET saldo = saldo + ? WHERE id = ?";
            try (PreparedStatement ps = con.prepareStatement(sqlUpdateSaldo)) {
                ps.setDouble(1, ev.getRecompensaDuts());
                ps.setInt(2, cuentaId);
                ps.executeUpdate();
            }

            // 3. Registrar movimiento de INGRESO
            String sqlMov = "INSERT INTO movimientos_duts (cuenta_id, tipo, monto, descripcion, referencia) " +
                            "VALUES (?, 'INGRESO', ?, ?, ?)";
            try (PreparedStatement ps = con.prepareStatement(sqlMov)) {
                ps.setInt(1, cuentaId);
                ps.setDouble(2, ev.getRecompensaDuts());
                ps.setString(3, "Recompensa evento: " + ev.getNombre());
                ps.setString(4, "REC-EVT-" + eventoId + "-" + System.currentTimeMillis());
                ps.executeUpdate();
            }

            // 4. Actualizar estado de inscripción a RECOMPENSADO
            String sqlInsc = "UPDATE inscripciones_eventos SET estado = 'RECOMPENSADO' WHERE usuario_id = ? AND evento_id = ?";
            try (PreparedStatement ps = con.prepareStatement(sqlInsc)) {
                ps.setInt(1, usuarioId);
                ps.setInt(2, eventoId);
                ps.executeUpdate();
            }

            con.commit();
            return true;
        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); con.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }

    private Evento mapearEvento(ResultSet rs) throws SQLException {
        Evento ev = new Evento();
        ev.setId(rs.getInt("id"));
        ev.setNombre(rs.getString("nombre"));
        ev.setDescripcion(rs.getString("descripcion"));
        ev.setFecha(rs.getTimestamp("fecha"));
        ev.setLugar(rs.getString("lugar"));
        ev.setCategoria(rs.getString("categoria"));
        ev.setRecompensaDuts(rs.getDouble("recompensa_duts"));
        ev.setCupos(rs.getInt("cupos"));
        ev.setEstado(rs.getString("estado"));
        try {
            ev.setImagenUrl(rs.getString("imagen_url"));
        } catch (SQLException ignored) {}
        try {
            ev.setDireccion(rs.getString("direccion"));
        } catch (SQLException ignored) {}
        try {
            ev.setUniversidad(rs.getString("universidad"));
        } catch (SQLException ignored) {}
        try {
            ev.setHoraInicio(rs.getString("hora_inicio"));
        } catch (SQLException ignored) {}
        try {
            ev.setHoraFin(rs.getString("hora_fin"));
        } catch (SQLException ignored) {}
        try {
            ev.setModalidad(rs.getString("modalidad"));
        } catch (SQLException ignored) {}
        try {
            ev.setRequisitos(rs.getString("requisitos"));
        } catch (SQLException ignored) {}
        return ev;
    }
}
