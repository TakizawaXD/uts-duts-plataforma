package co.edu.uts.duts.service;

import co.edu.uts.duts.dao.EventoDAO;
import co.edu.uts.duts.model.Evento;
import co.edu.uts.duts.model.Usuario;

import java.util.ArrayList;
import java.util.List;

/**
 * Servicio de lógica de negocio para Eventos Institucionales UTS.
 * Centraliza filtros, cálculo de métricas y validaciones de inscripción.
 */
public class EventoService {

    private final EventoDAO eventoDAO;

    public EventoService() {
        this.eventoDAO = new EventoDAO();
    }

    public EventoService(EventoDAO eventoDAO) {
        this.eventoDAO = eventoDAO;
    }

    /**
     * Obtiene los eventos correspondientes según el rol del usuario:
     * Si es Administrador obtiene todos los eventos (activos e inactivos).
     * Si es Estudiante obtiene los activos con estado de su inscripción.
     */
    public List<Evento> listarPorUsuario(Usuario usuario) {
        if (usuario == null) {
            return new ArrayList<>();
        }
        if (usuario.getRolId() == 2) {
            return eventoDAO.listarTodos();
        }
        return eventoDAO.listarActivos(usuario.getId());
    }

    /**
     * Filtra una lista de eventos por categoría, universidad y término de búsqueda.
     */
    public List<Evento> filtrarEventos(List<Evento> baseEventos, String categoria, String universidad, String buscar) {
        if (baseEventos == null) {
            return new ArrayList<>();
        }

        List<Evento> resultado = new ArrayList<>();
        for (Evento e : baseEventos) {
            boolean coincideCat = (categoria == null || categoria.trim().isEmpty() || "TODOS".equalsIgnoreCase(categoria) ||
                    (e.getCategoria() != null && e.getCategoria().equalsIgnoreCase(categoria.trim())));

            boolean coincideUni = (universidad == null || universidad.trim().isEmpty() || "TODAS".equalsIgnoreCase(universidad) ||
                    (e.getUniversidad() != null && e.getUniversidad().equalsIgnoreCase(universidad.trim())));

            boolean coincideBus = (buscar == null || buscar.trim().isEmpty() ||
                    (e.getNombre() != null && e.getNombre().toLowerCase().contains(buscar.toLowerCase().trim())) ||
                    (e.getLugar() != null && e.getLugar().toLowerCase().contains(buscar.toLowerCase().trim())) ||
                    (e.getUniversidad() != null && e.getUniversidad().toLowerCase().contains(buscar.toLowerCase().trim())) ||
                    (e.getDireccion() != null && e.getDireccion().toLowerCase().contains(buscar.toLowerCase().trim())));

            if (coincideCat && coincideUni && coincideBus) {
                resultado.add(e);
            }
        }
        return resultado;
    }

    /**
     * Suma las recompensas DUTS de los eventos disponibles.
     */
    public double calcularTotalRecompensas(List<Evento> eventos) {
        if (eventos == null) return 0.0;
        double total = 0.0;
        for (Evento e : eventos) {
            total += e.getRecompensaDuts();
        }
        return total;
    }

    /**
     * Cuenta cuántos eventos tienen inscripción activa para el estudiante.
     */
    public int contarMisInscritos(List<Evento> eventos) {
        if (eventos == null) return 0;
        int count = 0;
        for (Evento e : eventos) {
            if (e.isInscrito()) {
                count++;
            }
        }
        return count;
    }

    public boolean inscribirUsuario(int usuarioId, int eventoId) {
        return eventoDAO.inscribirUsuario(usuarioId, eventoId);
    }

    public boolean cancelarInscripcion(int usuarioId, int eventoId) {
        return eventoDAO.cancelarInscripcion(usuarioId, eventoId);
    }

    public boolean reclamarRecompensa(int usuarioId, int eventoId) {
        return eventoDAO.reclamarRecompensa(usuarioId, eventoId);
    }

    public Evento obtenerPorId(int id) {
        return eventoDAO.obtenerPorId(id);
    }

    public boolean crear(Evento evento) {
        return eventoDAO.crear(evento);
    }

    public boolean actualizar(Evento evento) {
        return eventoDAO.actualizar(evento);
    }

    public boolean eliminar(int id) {
        return eventoDAO.eliminar(id);
    }
}
