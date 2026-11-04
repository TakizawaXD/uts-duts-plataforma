package co.edu.uts.duts.controller;

import co.edu.uts.duts.dao.TransferenciaDAO;
import co.edu.uts.duts.model.Usuario;
import co.edu.uts.duts.service.TransferenciaService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * TransferenciasServlet: Controlador del módulo P2P de transferencias DUTS.
 * Permite buscar destinatarios universitarios y enviar fondos de forma instantánea.
 */
@WebServlet("/transferencias")
public class TransferenciasServlet extends BaseServlet {

    private final TransferenciaService transferenciaService = new TransferenciaService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!asegurarAutenticacion(req, resp)) {
            return;
        }

        Usuario u = getUsuarioSesion(req);

        double saldo = transferenciaService.obtenerSaldoUsuario(u.getId());
        List<Map<String, Object>> transferencias = transferenciaService.listarTransferencias(u.getId());

        String queryBusqueda = getParamTrimmed(req, "buscar", null);
        List<Usuario> usuariosDisponibles = transferenciaService.buscarDestinatarios(u.getId(), queryBusqueda);

        String destinatarioPrefill = getParamTrimmed(req, "destinatario", null);
        if (destinatarioPrefill != null) {
            Usuario destSel = transferenciaService.obtenerDestinatario(destinatarioPrefill);
            if (destSel != null && destSel.getId() != u.getId()) {
                req.setAttribute("destinatarioSeleccionado", destSel);
            }
        }

        req.setAttribute("saldo", saldo);
        req.setAttribute("transferencias", transferencias);
        req.setAttribute("usuariosDisponibles", usuariosDisponibles);
        req.setAttribute("queryBusqueda", queryBusqueda != null ? queryBusqueda : "");

        transferirFlashMessages(req);
        forward(req, resp, "/transferencias.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!asegurarAutenticacion(req, resp)) {
            return;
        }

        Usuario u = getUsuarioSesion(req);
        String action = req.getParameter("action");

        if ("enviar".equals(action)) {
            String destinatario = getParamTrimmed(req, "destinatario", null);
            double monto = getParamDouble(req, "monto", 0.0);
            String concepto = getParamTrimmed(req, "concepto", "Transferencia DUTS entre compañeros");

            if (destinatario == null || monto <= 0) {
                setFlashError(req, "Por favor completa el destinatario y un monto válido mayor a 0 DUTS.");
            } else {
                TransferenciaDAO.ResultadoTransferencia resultado = transferenciaService.realizarTransferencia(
                        u.getId(),
                        destinatario,
                        monto,
                        concepto
                );

                if (resultado.isExitoso()) {
                    setFlashSuccess(req, resultado.getMensaje());
                } else {
                    setFlashError(req, resultado.getMensaje());
                }
            }
        }

        redirect(req, resp, "/transferencias");
    }
}
