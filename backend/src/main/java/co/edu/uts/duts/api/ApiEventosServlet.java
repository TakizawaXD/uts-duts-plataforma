package co.edu.uts.duts.api;

import co.edu.uts.duts.dao.EventoDAO;
import co.edu.uts.duts.model.Evento;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet({"/api/eventos", "/api/eventos/bucaramanga"})
public class ApiEventosServlet extends HttpServlet {

    private EventoDAO eventoDAO = new EventoDAO();
    private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Access-Control-Allow-Origin", "*");
        resp.setHeader("Access-Control-Allow-Methods", "GET");

        try {
            String uniFiltro = req.getParameter("universidad");
            String catFiltro = req.getParameter("categoria");
            String qFiltro = req.getParameter("q");

            List<Evento> eventos = eventoDAO.listarTodos();
            java.util.List<Evento> filtrados = new java.util.ArrayList<>();
            for (Evento e : eventos) {
                boolean matchUni = (uniFiltro == null || uniFiltro.trim().isEmpty() || "TODAS".equalsIgnoreCase(uniFiltro) || (e.getUniversidad() != null && e.getUniversidad().equalsIgnoreCase(uniFiltro.trim())));
                boolean matchCat = (catFiltro == null || catFiltro.trim().isEmpty() || "TODAS".equalsIgnoreCase(catFiltro) || (e.getCategoria() != null && e.getCategoria().equalsIgnoreCase(catFiltro.trim())));
                boolean matchQ = (qFiltro == null || qFiltro.trim().isEmpty() || 
                    (e.getNombre() != null && e.getNombre().toLowerCase().contains(qFiltro.toLowerCase().trim())) ||
                    (e.getDescripcion() != null && e.getDescripcion().toLowerCase().contains(qFiltro.toLowerCase().trim())) ||
                    (e.getLugar() != null && e.getLugar().toLowerCase().contains(qFiltro.toLowerCase().trim())));
                if (matchUni && matchCat && matchQ) {
                    filtrados.add(e);
                }
            }

            PrintWriter out = resp.getWriter();
            StringBuilder json = new StringBuilder();
            json.append("{\n");
            json.append("  \"status\": \"success\",\n");
            json.append("  \"origen\": \"API Red Universitaria de Bucaramanga y Santander\",\n");
            json.append("  \"red_academica\": [\"UTS (uts.edu.co)\", \"UIS (uis.edu.co)\", \"UNAB (unab.edu.co)\", \"UDES (udes.edu.co)\", \"ASCUN Nodo Santander\"],\n");
            json.append("  \"ciudad\": \"Bucaramanga, Santander\",\n");
            json.append("  \"total\": ").append(filtrados.size()).append(",\n");
            json.append("  \"eventos\": [\n");

            for (int i = 0; i < filtrados.size(); i++) {
                Evento e = filtrados.get(i);
                json.append("    {\n");
                json.append("      \"id\": ").append(e.getId()).append(",\n");
                json.append("      \"universidad\": \"").append(escapeJson(e.getUniversidad())).append("\",\n");
                json.append("      \"titulo\": \"").append(escapeJson(e.getNombre())).append("\",\n");
                json.append("      \"descripcion\": \"").append(escapeJson(e.getDescripcion())).append("\",\n");
                json.append("      \"categoria\": \"").append(escapeJson(e.getCategoria())).append("\",\n");
                json.append("      \"puntos\": ").append((long) e.getRecompensaDuts()).append(",\n");
                json.append("      \"recompensa_duts\": ").append(e.getRecompensaDuts()).append(",\n");
                json.append("      \"lugar\": \"").append(escapeJson(e.getLugar())).append("\",\n");
                json.append("      \"direccion\": \"").append(escapeJson(e.getDireccion())).append("\",\n");
                json.append("      \"imagen_url\": \"").append(escapeJson(e.getImagenUrl())).append("\",\n");
                json.append("      \"cupos\": ").append(e.getCupos()).append(",\n");
                json.append("      \"estado\": \"").append(escapeJson(e.getEstado())).append("\",\n");
                String mapsUrl = "https://www.google.com/maps/search/?api=1&query=" + java.net.URLEncoder.encode(e.getLugar() + ", " + e.getDireccion(), "UTF-8");
                json.append("      \"hora_inicio\": \"").append(escapeJson(e.getHoraInicio())).append("\",\n");
                json.append("      \"hora_fin\": \"").append(escapeJson(e.getHoraFin())).append("\",\n");
                json.append("      \"horario\": \"").append(escapeJson(e.getHoraInicio() + " - " + e.getHoraFin())).append("\",\n");
                json.append("      \"modalidad\": \"").append(escapeJson(e.getModalidad())).append("\",\n");
                json.append("      \"requisitos\": \"").append(escapeJson(e.getRequisitos())).append("\",\n");
                json.append("      \"google_maps_url\": \"").append(escapeJson(mapsUrl)).append("\",\n");
                json.append("      \"fecha\": \"").append(e.getFecha() != null ? sdf.format(e.getFecha()) : "").append("\"\n");
                json.append("    }").append(i < filtrados.size() - 1 ? "," : "").append("\n");
            }

            json.append("  ]\n");
            json.append("}");

            out.print(json.toString());
            out.flush();
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            PrintWriter out = resp.getWriter();
            out.print("{\"status\":\"error\",\"message\":\"Error al procesar la solicitud de eventos de la red universitaria.\"}");
            out.flush();
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\b", "\\b")
                .replace("\f", "\\f")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
