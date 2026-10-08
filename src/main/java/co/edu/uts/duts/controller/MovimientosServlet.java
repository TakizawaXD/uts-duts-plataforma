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
import co.edu.uts.duts.dao.MovimientoDAO;
import co.edu.uts.duts.model.Movimiento;
import co.edu.uts.duts.model.Usuario;

@WebServlet("/movimientos")
public class MovimientosServlet extends HttpServlet {

    private CuentaDAO cuentaDAO = new CuentaDAO();
    private MovimientoDAO movimientoDAO = new MovimientoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Usuario u = (Usuario) session.getAttribute("usuario");
        double saldo = cuentaDAO.obtenerSaldoPorUsuarioId(u.getId());

        // Obtener filtros si existen
        String tipo = req.getParameter("tipo");
        String buscar = req.getParameter("buscar");

        // Listar todos para calcular totales consolidados
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

        // Listar filtrados para la tabla
        List<Movimiento> movimientos;
        if ((tipo != null && !tipo.trim().isEmpty() && !"TODOS".equalsIgnoreCase(tipo)) || (buscar != null && !buscar.trim().isEmpty())) {
            movimientos = movimientoDAO.buscarPorUsuarioYFiltro(u.getId(), tipo, buscar);
        } else {
            movimientos = todos;
        }

        req.setAttribute("saldo", saldo);
        req.setAttribute("movimientos", movimientos);
        req.setAttribute("totalIngresos", totalIngresos);
        req.setAttribute("totalEgresos", totalEgresos);
        req.setAttribute("totalMovimientos", todos.size());
        req.setAttribute("filtroTipo", tipo != null ? tipo : "TODOS");
        req.setAttribute("filtroBuscar", buscar != null ? buscar : "");

        req.getRequestDispatcher("/movimientos.jsp").forward(req, resp);
    }
}
