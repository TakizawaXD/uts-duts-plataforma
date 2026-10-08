package co.edu.uts.duts.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import co.edu.uts.duts.dao.CuentaDAO;
import co.edu.uts.duts.dao.TransferenciaDAO;
import co.edu.uts.duts.dao.UsuarioDAO;
import co.edu.uts.duts.model.Usuario;

@WebServlet("/transferencias")
public class TransferenciasServlet extends HttpServlet {

    private CuentaDAO cuentaDAO = new CuentaDAO();
    private TransferenciaDAO transferenciaDAO = new TransferenciaDAO();
    private UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Usuario u = (Usuario) session.getAttribute("usuario");

        // Cargar saldo actual y el historial de transferencias
        double saldo = cuentaDAO.obtenerSaldoPorUsuarioId(u.getId());
        List<Map<String, Object>> transferencias = transferenciaDAO.listarTransferenciasUsuario(u.getId());

        // Buscar/listar destinatarios disponibles en la base de datos excluyendo al usuario actual
        String queryBusqueda = req.getParameter("buscar");
        List<Usuario> usuariosDisponibles = usuarioDAO.buscarDestinatarios(u.getId(), queryBusqueda);

        // Si se envió un destinatario preseleccionado, buscar su información detallada
        String destinatarioPrefill = req.getParameter("destinatario");
        if (destinatarioPrefill != null && !destinatarioPrefill.trim().isEmpty()) {
            Usuario destSel = usuarioDAO.obtenerPorUsernameOCodigo(destinatarioPrefill.trim());
            if (destSel != null && destSel.getId() != u.getId()) {
                req.setAttribute("destinatarioSeleccionado", destSel);
            }
        }

        req.setAttribute("saldo", saldo);
        req.setAttribute("transferencias", transferencias);
        req.setAttribute("usuariosDisponibles", usuariosDisponibles);
        req.setAttribute("queryBusqueda", queryBusqueda);

        if (session.getAttribute("flashSuccess") != null) {
            req.setAttribute("flashSuccess", session.getAttribute("flashSuccess"));
            session.removeAttribute("flashSuccess");
        }
        if (session.getAttribute("flashError") != null) {
            req.setAttribute("flashError", session.getAttribute("flashError"));
            session.removeAttribute("flashError");
        }

        req.getRequestDispatcher("/transferencias.jsp").forward(req, resp);
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

        if ("enviar".equals(action)) {
            String destinatario = req.getParameter("destinatario");
            String montoStr = req.getParameter("monto");
            String concepto = req.getParameter("concepto");

            if (destinatario == null || destinatario.trim().isEmpty() || montoStr == null || montoStr.trim().isEmpty()) {
                session.setAttribute("flashError", "Por favor completa todos los campos obligatorios.");
            } else {
                try {
                    double monto = Double.parseDouble(montoStr.trim());
                    TransferenciaDAO.ResultadoTransferencia resultado = transferenciaDAO.transferirDuts(
                            u.getId(),
                            destinatario.trim(),
                            monto,
                            concepto
                    );

                    if (resultado.isExitoso()) {
                        session.setAttribute("flashSuccess", resultado.getMensaje());
                    } else {
                        session.setAttribute("flashError", resultado.getMensaje());
                    }
                } catch (NumberFormatException e) {
                    session.setAttribute("flashError", "El monto ingresado no es un número válido.");
                }
            }
        }

        resp.sendRedirect(req.getContextPath() + "/transferencias");
    }
}
