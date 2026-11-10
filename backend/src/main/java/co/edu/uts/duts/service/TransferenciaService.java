package co.edu.uts.duts.service;

import co.edu.uts.duts.dao.CuentaDAO;
import co.edu.uts.duts.dao.TransferenciaDAO;
import co.edu.uts.duts.dao.UsuarioDAO;
import co.edu.uts.duts.model.Usuario;

import java.util.List;
import java.util.Map;

/**
 * Servicio de lógica de negocio para operaciones y transferencias DUTS.
 * Valida montos, previene auto-transferencias y coordina cuentas de saldo.
 */
public class TransferenciaService {

    private final TransferenciaDAO transferenciaDAO;
    private final CuentaDAO cuentaDAO;
    private final UsuarioDAO usuarioDAO;

    public TransferenciaService() {
        this.transferenciaDAO = new TransferenciaDAO();
        this.cuentaDAO = new CuentaDAO();
        this.usuarioDAO = new UsuarioDAO();
    }

    public double obtenerSaldoUsuario(int usuarioId) {
        return cuentaDAO.obtenerSaldoPorUsuarioId(usuarioId);
    }

    public List<Map<String, Object>> listarTransferencias(int usuarioId) {
        return transferenciaDAO.listarTransferenciasUsuario(usuarioId);
    }

    public List<Usuario> buscarDestinatarios(int usuarioActualId, String query) {
        return usuarioDAO.buscarDestinatarios(usuarioActualId, query);
    }

    public Usuario obtenerDestinatario(String identificador) {
        if (identificador == null || identificador.trim().isEmpty()) {
            return null;
        }
        return usuarioDAO.obtenerPorUsernameOCodigo(identificador.trim());
    }

    public TransferenciaDAO.ResultadoTransferencia realizarTransferencia(int remitenteId, String destinatario, double monto, String concepto) {
        if (destinatario == null || destinatario.trim().isEmpty()) {
            return new TransferenciaDAO.ResultadoTransferencia(false, "El destinatario es obligatorio.");
        }
        if (monto <= 0) {
            return new TransferenciaDAO.ResultadoTransferencia(false, "El monto a transferir debe ser mayor a 0 DUTS.");
        }
        return transferenciaDAO.transferirDuts(remitenteId, destinatario.trim(), monto, concepto);
    }

    public TransferenciaDAO.ResultadoTransferencia recargarSaldoSimulado(int usuarioId, double monto) {
        if (monto <= 0) {
            return new TransferenciaDAO.ResultadoTransferencia(false, "El monto de recarga debe ser positivo.");
        }
        return transferenciaDAO.recargarSaldoSimulado(usuarioId, monto);
    }
}
