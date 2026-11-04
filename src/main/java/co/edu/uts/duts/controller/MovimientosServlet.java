package co.edu.uts.duts.controller;

import co.edu.uts.duts.dao.CuentaDAO;
import co.edu.uts.duts.dao.MovimientoDAO;
import co.edu.uts.duts.model.Movimiento;
import co.edu.uts.duts.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * MovimientosServlet: Historial transaccional y extractos de cuenta del usuario.
 * Permite filtrar por tipo de operación y búsqueda de conceptos.
 */
@WebServlet("/movimientos")
public class MovimientosServlet extends BaseServlet {

    private final CuentaDAO cuentaDAO = new CuentaDAO();
    private final MovimientoDAO movimientoDAO = new MovimientoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!asegurarAutenticacion(req, resp)) {
            return;
        }

        Usuario u = getUsuarioSesion(req);
        double saldo = cuentaDAO.obtenerSaldoPorUsuarioId(u.getId());

        String tipo = getParamTrimmed(req, "tipo", "TODOS");
        String buscar = getParamTrimmed(req, "buscar", "");

        List<Movimiento> todos = movimientoDAO.listarPorUsuario(u.getId(), 0);
        double totalIngresos = 0.0;
        double totalEgresos = 0.0;
        for (Movimiento m : todos) {
            if ("INGRESO".equalsIgnoreCase(m.getTipo())) {
                totalIngresos += m.getMonto();
            } else {
                totalEgresos += m.getMonto();
            }
        }

        List<Movimiento> movimientos;
        if (!"TODOS".equalsIgnoreCase(tipo) || !buscar.isEmpty()) {
            movimientos = movimientoDAO.buscarPorUsuarioYFiltro(u.getId(), tipo, buscar);
        } else {
            movimientos = todos;
        }

        req.setAttribute("saldo", saldo);
        req.setAttribute("movimientos", movimientos);
        req.setAttribute("totalIngresos", totalIngresos);
        req.setAttribute("totalEgresos", totalEgresos);
        req.setAttribute("totalMovimientos", todos.size());
        req.setAttribute("filtroTipo", tipo);
        req.setAttribute("filtroBuscar", buscar);

        transferirFlashMessages(req);
        forward(req, resp, "/movimientos.jsp");
    }
}
