package co.edu.uts.duts.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

import co.edu.uts.duts.dao.CuentaDAO;
import co.edu.uts.duts.dao.EventoDAO;
import co.edu.uts.duts.dao.MovimientoDAO;
import co.edu.uts.duts.dao.TransferenciaDAO;
import co.edu.uts.duts.model.Evento;
import co.edu.uts.duts.model.Movimiento;
import co.edu.uts.duts.model.Usuario;

@WebServlet({"/dashboard", "/inicio"})
public class DashboardServlet extends HttpServlet {
    
    private CuentaDAO cuentaDAO = new CuentaDAO();
    private EventoDAO eventoDAO = new EventoDAO();
    private MovimientoDAO movimientoDAO = new MovimientoDAO();
    private TransferenciaDAO transferenciaDAO = new TransferenciaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        
        Usuario u = (Usuario) session.getAttribute("usuario");
        
        // 1. Obtener saldo en tiempo real desde la BD
        double saldo = cuentaDAO.obtenerSaldoPorUsuarioId(u.getId());
        req.setAttribute("saldo", saldo);

        // 2. Obtener eventos activos y verificar si el estudiante está inscrito
        List<Evento> eventos = eventoDAO.listarActivos(u.getId());
        req.setAttribute("eventos", eventos);

        // 3. Obtener últimos movimientos
        List<Movimiento> movimientos = movimientoDAO.listarPorUsuario(u.getId(), 6);
        req.setAttribute("movimientos", movimientos);

        // 4. Métricas analíticas (promedio semana, mes, año, semestre) y meta de graduación (70.000 DUTS)
        co.edu.uts.duts.model.MetricasDuts metricas = movimientoDAO.obtenerMetricasDuts(u.getId(), saldo, u.getSemestre());
        req.setAttribute("metricas", metricas);

        // 5. Mover mensajes flash de sesión a la solicitud si existen
        if (session.getAttribute("flashSuccess") != null) {
            req.setAttribute("flashSuccess", session.getAttribute("flashSuccess"));
            session.removeAttribute("flashSuccess");
        }
        if (session.getAttribute("flashError") != null) {
            req.setAttribute("flashError", session.getAttribute("flashError"));
            session.removeAttribute("flashError");
        }

        req.getRequestDispatcher("/dashboard.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Usuario u = (Usuario) session.getAttribute("usuario");
        String action = req.getParameter("action");

        // Acción rápida para recargar saldo de estímulo en la plataforma
        if ("recargar_estimulo".equals(action)) {
            TransferenciaDAO.ResultadoTransferencia res = transferenciaDAO.recargarSaldoSimulado(u.getId(), 5000.0);
            if (res.isExitoso()) {
                session.setAttribute("flashSuccess", res.getMensaje());
            } else {
                session.setAttribute("flashError", res.getMensaje());
            }
        } else if ("inscribir_evento".equals(action)) {
            try {
                int eventoId = Integer.parseInt(req.getParameter("eventoId"));
                boolean ok = eventoDAO.inscribirUsuario(u.getId(), eventoId);
                if (ok) {
                    session.setAttribute("flashSuccess", "Inscripción al evento realizada exitosamente.");
                } else {
                    session.setAttribute("flashError", "Ya te encuentras inscrito o el evento no está disponible.");
                }
            } catch (Exception e) {
                session.setAttribute("flashError", "Datos del evento inválidos.");
            }
        } else if ("reclamar_recompensa".equals(action)) {
            try {
                int eventoId = Integer.parseInt(req.getParameter("eventoId"));
                boolean ok = eventoDAO.reclamarRecompensa(u.getId(), eventoId);
                if (ok) {
                    session.setAttribute("flashSuccess", "Recompensa reclamada exitosamente. Tu saldo DUTS ha sido incrementado.");
                } else {
                    session.setAttribute("flashError", "No se pudo reclamar la recompensa del evento.");
                }
            } catch (Exception e) {
                session.setAttribute("flashError", "Error al procesar la recompensa.");
            }
        }

        resp.sendRedirect(req.getContextPath() + "/dashboard");
    }
}
