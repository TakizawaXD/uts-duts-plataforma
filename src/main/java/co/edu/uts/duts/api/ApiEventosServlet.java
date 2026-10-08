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

        List<Evento> eventos = eventoDAO.listarTodos();

        PrintWriter out = resp.getWriter();
        StringBuilder json = new StringBuilder();
        json.append("{\n");
        json.append("  \"status\": \"success\",\n");
        json.append("  \"origen\": \"API Red Universitaria de Bucaramanga (UTS, UIS, UNAB, UDES)\",\n");
        json.append("  \"ciudad\": \"Bucaramanga, Santander\",\n");
        json.append("  \"total\": ").append(eventos.size()).append(",\n");
        json.append("  \"eventos\": [\n");

        for (int i = 0; i < eventos.size(); i++) {
            Evento e = eventos.get(i);
            json.append("    {\n");
            json.append("      \"id\": ").append(e.getId()).append(",\n");
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
            json.append("      \"fecha\": \"").append(e.getFecha() != null ? sdf.format(e.getFecha()) : "").append("\"\n");
            json.append("    }").append(i < eventos.size() - 1 ? "," : "").append("\n");
        }

        json.append("  ]\n");
        json.append("}");

        out.print(json.toString());
        out.flush();
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
