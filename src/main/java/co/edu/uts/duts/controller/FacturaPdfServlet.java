package co.edu.uts.duts.controller;

import co.edu.uts.duts.dao.CuentaDAO;
import co.edu.uts.duts.dao.MovimientoDAO;
import co.edu.uts.duts.model.Movimiento;
import co.edu.uts.duts.model.Usuario;
import co.edu.uts.duts.service.PdfExportService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;

/**
 * FacturaPdfServlet: Controlador HTTP para la descarga de comprobantes individuales
 * y extractos consolidados en formato PDF. Delega la renderización a PdfExportService.
 */
@WebServlet({"/factura/pdf", "/movimientos/pdf"})
public class FacturaPdfServlet extends BaseServlet {

    private final CuentaDAO cuentaDAO = new CuentaDAO();
    private final MovimientoDAO movimientoDAO = new MovimientoDAO();
    private final PdfExportService pdfExportService = new PdfExportService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!asegurarAutenticacion(req, resp)) {
            return;
        }

        Usuario u = getUsuarioSesion(req);
        String idStr = req.getParameter("id");
        String logoPath = getServletContext().getRealPath("/assets/images/logouts.png");

        try {
            ByteArrayOutputStream baos = new ByteArrayOutputStream();

            // Factura individual de un movimiento específico
            if (idStr != null && !idStr.trim().isEmpty()) {
                int movId = Integer.parseInt(idStr.trim());
                Movimiento m = movimientoDAO.obtenerPorIdYUsuario(movId, u.getId());
                if (m != null) {
                    pdfExportService.exportarFacturaIndividual(baos, u, m, logoPath);
                    enviarPdf(resp, baos, "Factura_DUTS_" + m.getReferencia() + ".pdf");
                    return;
                }
            }

            // Extracto consolidado completo
            double saldo = cuentaDAO.obtenerSaldoPorUsuarioId(u.getId());
            List<Movimiento> movimientos = movimientoDAO.listarPorUsuario(u.getId(), 0);
            pdfExportService.exportarExtractoCompleto(baos, u, saldo, movimientos, logoPath);
            enviarPdf(resp, baos, "Extracto_DUTS_" + u.getCodigoEstudiantil() + ".pdf");

        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error generando PDF: " + e.getMessage());
        }
    }

    private void enviarPdf(HttpServletResponse resp, ByteArrayOutputStream baos, String filename) throws IOException {
        resp.setContentType("application/pdf");
        resp.setHeader("Content-Disposition", "inline; filename=\"" + filename + "\"");
        resp.setContentLength(baos.size());
        resp.getOutputStream().write(baos.toByteArray());
        resp.getOutputStream().flush();
    }
}
