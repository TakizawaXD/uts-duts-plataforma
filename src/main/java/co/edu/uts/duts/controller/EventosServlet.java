package co.edu.uts.duts.controller;

import co.edu.uts.duts.dao.CuentaDAO;
import co.edu.uts.duts.model.Evento;
import co.edu.uts.duts.model.Usuario;
import co.edu.uts.duts.service.EventoService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

/**
 * EventosServlet: Gestión del catálogo, inscripciones y recompensas de eventos UTS.
 * Permite a estudiantes inscribirse y a administradores gestionar el ciclo de vida (CRUD).
 */
@WebServlet("/eventos")
public class EventosServlet extends BaseServlet {

    private final EventoService eventoService = new EventoService();
    private final CuentaDAO cuentaDAO = new CuentaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!asegurarAutenticacion(req, resp)) {
            return;
        }

        Usuario u = getUsuarioSesion(req);
        boolean esAdmin = (u.getRolId() == 2);

        List<Evento> baseEventos = eventoService.listarPorUsuario(u);

        // Filtros opcionales
        String categoria = getParamTrimmed(req, "categoria", "TODOS");
        String universidad = getParamTrimmed(req, "universidad", "TODAS");
        String buscar = getParamTrimmed(req, "buscar", "");

        List<Evento> eventosFiltrados = eventoService.filtrarEventos(baseEventos, categoria, universidad, buscar);

        // Atributos para la vista
        req.setAttribute("eventos", eventosFiltrados);
        req.setAttribute("todosEventosAdmin", esAdmin ? baseEventos : null);
        req.setAttribute("totalEventosDisponibles", baseEventos.size());
        req.setAttribute("totalRecompensas", eventoService.calcularTotalRecompensas(baseEventos));
        req.setAttribute("misInscritosCount", eventoService.contarMisInscritos(baseEventos));
        req.setAttribute("filtroCategoria", categoria);
        req.setAttribute("filtroUniversidad", universidad);
        req.setAttribute("filtroBuscar", buscar);
        req.setAttribute("saldo", cuentaDAO.obtenerSaldoPorUsuarioId(u.getId()));
        req.setAttribute("esAdmin", esAdmin);

        // Formulario de edición administrativa si se especificó editId
        int editId = getParamInt(req, "editId", -1);
        if (editId > 0 && esAdmin) {
            req.setAttribute("eventoEditar", eventoService.obtenerPorId(editId));
        }

        transferirFlashMessages(req);
        forward(req, resp, "/eventos.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!asegurarAutenticacion(req, resp)) {
            return;
        }

        Usuario u = getUsuarioSesion(req);
        boolean esAdmin = (u.getRolId() == 2);
        String action = req.getParameter("action");

        if ("inscribir".equals(action)) {
            int eventoId = getParamInt(req, "eventoId", -1);
            if (eventoId > 0 && eventoService.inscribirUsuario(u.getId(), eventoId)) {
                setFlashSuccess(req, "Inscripción confirmada para el evento.");
            } else {
                setFlashError(req, "No fue posible realizar la inscripción.");
            }
        } else if ("cancelar_inscripcion".equals(action)) {
            int eventoId = getParamInt(req, "eventoId", -1);
            if (eventoId > 0 && eventoService.cancelarInscripcion(u.getId(), eventoId)) {
                setFlashSuccess(req, "Has cancelado tu inscripción al evento.");
            } else {
                setFlashError(req, "Error al cancelar la inscripción.");
            }
        } else if ("reclamar".equals(action)) {
            int eventoId = getParamInt(req, "eventoId", -1);
            if (eventoId > 0 && eventoService.reclamarRecompensa(u.getId(), eventoId)) {
                setFlashSuccess(req, "Recompensa acreditada a tu saldo exitosamente.");
            } else {
                setFlashError(req, "No se pudo acreditar la recompensa.");
            }
        } else if (esAdmin) {
            procesarAccionesAdmin(req, action);
        }

        redirect(req, resp, "/eventos");
    }

    private void procesarAccionesAdmin(HttpServletRequest req, String action) {
        if ("crear".equals(action)) {
            try {
                Evento nuevo = mapearEventoDesdePeticion(req, new Evento());
                if (eventoService.crear(nuevo)) {
                    setFlashSuccess(req, "Evento creado satisfactoriamente.");
                } else {
                    setFlashError(req, "Error al registrar el evento en la base de datos.");
                }
            } catch (Exception e) {
                setFlashError(req, "Formato de datos inválido al crear evento: " + e.getMessage());
            }
        } else if ("actualizar".equals(action)) {
            try {
                int id = getParamInt(req, "id", -1);
                Evento mod = eventoService.obtenerPorId(id);
                if (mod != null) {
                    mapearEventoDesdePeticion(req, mod);
                    if (eventoService.actualizar(mod)) {
                        setFlashSuccess(req, "Evento actualizado satisfactoriamente.");
                    } else {
                        setFlashError(req, "No se pudo actualizar el evento.");
                    }
                }
            } catch (Exception e) {
                setFlashError(req, "Error al actualizar evento: " + e.getMessage());
            }
        } else if ("eliminar".equals(action)) {
            int id = getParamInt(req, "id", -1);
            if (id > 0 && eventoService.eliminar(id)) {
                setFlashSuccess(req, "Evento eliminado de la base de datos.");
            } else {
                setFlashError(req, "No se pudo eliminar el evento.");
            }
        }
    }

    private Evento mapearEventoDesdePeticion(HttpServletRequest req, Evento e) {
        e.setNombre(getParamTrimmed(req, "nombre", ""));
        e.setDescripcion(getParamTrimmed(req, "descripcion", ""));
        e.setLugar(getParamTrimmed(req, "lugar", ""));
        e.setCategoria(getParamTrimmed(req, "categoria", "ACADÉMICO"));
        e.setRecompensaDuts(getParamDouble(req, "recompensaDuts", 0.0));
        e.setCupos(getParamInt(req, "cupos", 50));
        e.setEstado(getParamTrimmed(req, "estado", "ACTIVO"));
        e.setDireccion(getParamTrimmed(req, "direccion", "Campus Principal UTS"));
        e.setUniversidad(getParamTrimmed(req, "universidad", "UTS Bucaramanga"));
        e.setImagenUrl(getParamTrimmed(req, "imagenUrl", "https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&auto=format&fit=crop&q=80"));

        String fechaStr = req.getParameter("fecha");
        if (fechaStr != null && !fechaStr.trim().isEmpty()) {
            fechaStr = fechaStr.replace("T", " ").trim();
            if (fechaStr.length() == 16) fechaStr += ":00";
            e.setFecha(Timestamp.valueOf(fechaStr));
        } else if (e.getFecha() == null) {
            e.setFecha(new Timestamp(System.currentTimeMillis()));
        }
        return e;
    }
}
