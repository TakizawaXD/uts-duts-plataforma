package co.edu.uts.duts.controller;

import co.edu.uts.duts.dao.CuentaDAO;
import co.edu.uts.duts.dao.MovimientoDAO;
import co.edu.uts.duts.dao.TransferenciaDAO;
import co.edu.uts.duts.model.Evento;
import co.edu.uts.duts.model.MetricasDuts;
import co.edu.uts.duts.model.Movimiento;
import co.edu.uts.duts.model.Usuario;
import co.edu.uts.duts.service.EventoService;
import co.edu.uts.duts.service.TransferenciaService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * DashboardServlet: Panel de control principal del ecosistema DUTS.
 * Proporciona balance en tiempo real, métricas analíticas y accesos directos.
 */
@WebServlet({"/dashboard", "/inicio"})
public class DashboardServlet extends BaseServlet {

    private final CuentaDAO cuentaDAO = new CuentaDAO();
    private final MovimientoDAO movimientoDAO = new MovimientoDAO();
    private final EventoService eventoService = new EventoService();
    private final TransferenciaService transferenciaService = new TransferenciaService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!asegurarAutenticacion(req, resp)) {
            return;
        }

        Usuario u = getUsuarioSesion(req);

        // 1. Saldo actual
        double saldo = cuentaDAO.obtenerSaldoPorUsuarioId(u.getId());
        req.setAttribute("saldo", saldo);

        // 2. Eventos activos para el estudiante
        List<Evento> eventos = eventoService.listarPorUsuario(u);
        req.setAttribute("eventos", eventos);

        // 3. Últimos movimientos (límite 6)
        List<Movimiento> movimientos = movimientoDAO.listarPorUsuario(u.getId(), 6);
        req.setAttribute("movimientos", movimientos);

        // 4. Métricas analíticas de avance hacia la meta institucional
        MetricasDuts metricas = movimientoDAO.obtenerMetricasDuts(u.getId(), saldo, u.getSemestre());
        req.setAttribute("metricas", metricas);

        // 5. Transferir mensajes flash para renderizado en JSP
        transferirFlashMessages(req);

        forward(req, resp, "/dashboard.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!asegurarAutenticacion(req, resp)) {
            return;
        }

        Usuario u = getUsuarioSesion(req);
        String action = req.getParameter("action");

        if ("recargar_estimulo".equals(action)) {
            TransferenciaDAO.ResultadoTransferencia res = transferenciaService.recargarSaldoSimulado(u.getId(), 5000.0);
            if (res.isExitoso()) {
                setFlashSuccess(req, res.getMensaje());
            } else {
                setFlashError(req, res.getMensaje());
            }
        } else if ("inscribir_evento".equals(action)) {
            int eventoId = getParamInt(req, "eventoId", -1);
            if (eventoId > 0 && eventoService.inscribirUsuario(u.getId(), eventoId)) {
                setFlashSuccess(req, "Inscripción al evento realizada exitosamente.");
            } else {
                setFlashError(req, "Ya te encuentras inscrito o el evento no está disponible.");
            }
        } else if ("reclamar_recompensa".equals(action)) {
            int eventoId = getParamInt(req, "eventoId", -1);
            if (eventoId > 0 && eventoService.reclamarRecompensa(u.getId(), eventoId)) {
                setFlashSuccess(req, "Recompensa reclamada exitosamente. Tu saldo DUTS ha sido incrementado.");
            } else {
                setFlashError(req, "No se pudo reclamar la recompensa del evento.");
            }
        }

        redirect(req, resp, "/dashboard");
    }
}
