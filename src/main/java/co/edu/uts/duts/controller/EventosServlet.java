package co.edu.uts.duts.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import co.edu.uts.duts.dao.CuentaDAO;
import co.edu.uts.duts.dao.EventoDAO;
import co.edu.uts.duts.model.Evento;
import co.edu.uts.duts.model.Usuario;

@WebServlet("/eventos")
public class EventosServlet extends HttpServlet {

    private EventoDAO eventoDAO = new EventoDAO();
    private CuentaDAO cuentaDAO = new CuentaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Usuario u = (Usuario) session.getAttribute("usuario");
        boolean esAdmin = (u.getRolId() == 2);

        // Si es admin, puede ver todos los eventos para gestión CRUD
        // Si es estudiante, ve los eventos activos con estado de su inscripción
        List<Evento> baseEventos;
        List<Evento> todosEventos = null;
        if (esAdmin) {
            todosEventos = eventoDAO.listarTodos();
            baseEventos = todosEventos;
        } else {
            baseEventos = eventoDAO.listarActivos(u.getId());
        }

        // Calcular estadísticas y métricas para las tarjetas KPI
        double totalRecompensas = 0.0;
        int misInscritosCount = 0;
        for (Evento e : baseEventos) {
            totalRecompensas += e.getRecompensaDuts();
            if (e.isInscrito()) {
                misInscritosCount++;
            }
        }

        // Filtros opcionales por categoría, universidad y texto
        String categoriaFiltro = req.getParameter("categoria");
        String universidadFiltro = req.getParameter("universidad");
        String buscarFiltro = req.getParameter("buscar");

        List<Evento> eventosFiltrados = new ArrayList<>();
        for (Evento e : baseEventos) {
            boolean coincideCat = (categoriaFiltro == null || categoriaFiltro.trim().isEmpty() || "TODOS".equalsIgnoreCase(categoriaFiltro) || (e.getCategoria() != null && e.getCategoria().equalsIgnoreCase(categoriaFiltro.trim())));
            boolean coincideUni = (universidadFiltro == null || universidadFiltro.trim().isEmpty() || "TODAS".equalsIgnoreCase(universidadFiltro) || (e.getUniversidad() != null && e.getUniversidad().equalsIgnoreCase(universidadFiltro.trim())));
            boolean coincideBus = (buscarFiltro == null || buscarFiltro.trim().isEmpty() || 
                (e.getNombre() != null && e.getNombre().toLowerCase().contains(buscarFiltro.toLowerCase().trim())) || 
                (e.getLugar() != null && e.getLugar().toLowerCase().contains(buscarFiltro.toLowerCase().trim())) ||
                (e.getUniversidad() != null && e.getUniversidad().toLowerCase().contains(buscarFiltro.toLowerCase().trim())) ||
                (e.getDireccion() != null && e.getDireccion().toLowerCase().contains(buscarFiltro.toLowerCase().trim())));
            if (coincideCat && coincideUni && coincideBus) {
                eventosFiltrados.add(e);
            }
        }

        req.setAttribute("eventos", eventosFiltrados);
        req.setAttribute("todosEventosAdmin", todosEventos);
        req.setAttribute("totalEventosDisponibles", baseEventos.size());
        req.setAttribute("totalRecompensas", totalRecompensas);
        req.setAttribute("misInscritosCount", misInscritosCount);
        req.setAttribute("filtroCategoria", categoriaFiltro != null ? categoriaFiltro : "TODOS");
        req.setAttribute("filtroUniversidad", universidadFiltro != null ? universidadFiltro : "TODAS");
        req.setAttribute("filtroBuscar", buscarFiltro != null ? buscarFiltro : "");

        // Si el admin solicitó editar un evento en particular
        String editIdParam = req.getParameter("editId");
        if (editIdParam != null && !editIdParam.isEmpty() && esAdmin) {
            try {
                int editId = Integer.parseInt(editIdParam);
                Evento eventoAEditar = eventoDAO.obtenerPorId(editId);
                req.setAttribute("eventoEditar", eventoAEditar);
            } catch (Exception ignored) {}
        }

        req.setAttribute("saldo", cuentaDAO.obtenerSaldoPorUsuarioId(u.getId()));
        req.setAttribute("esAdmin", esAdmin);

        // Mensajes Flash
        if (session.getAttribute("flashSuccess") != null) {
            req.setAttribute("flashSuccess", session.getAttribute("flashSuccess"));
            session.removeAttribute("flashSuccess");
        }
        if (session.getAttribute("flashError") != null) {
            req.setAttribute("flashError", session.getAttribute("flashError"));
            session.removeAttribute("flashError");
        }

        req.getRequestDispatcher("/eventos.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Usuario u = (Usuario) session.getAttribute("usuario");
        boolean esAdmin = (u.getRolId() == 2);
        String action = req.getParameter("action");

        if ("inscribir".equals(action)) {
            try {
                int eventoId = Integer.parseInt(req.getParameter("eventoId"));
                boolean ok = eventoDAO.inscribirUsuario(u.getId(), eventoId);
                if (ok) {
                    session.setAttribute("flashSuccess", "Inscripción confirmada para el evento.");
                } else {
                    session.setAttribute("flashError", "No fue posible realizar la inscripción.");
                }
            } catch (Exception e) {
                session.setAttribute("flashError", "Error al procesar la inscripción.");
            }
        } else if ("cancelar_inscripcion".equals(action)) {
            try {
                int eventoId = Integer.parseInt(req.getParameter("eventoId"));
                boolean ok = eventoDAO.cancelarInscripcion(u.getId(), eventoId);
                if (ok) {
                    session.setAttribute("flashSuccess", "Has cancelado tu inscripción al evento.");
                } else {
                    session.setAttribute("flashError", "Error al cancelar la inscripción.");
                }
            } catch (Exception e) {
                session.setAttribute("flashError", "Error en la solicitud.");
            }
        } else if ("reclamar".equals(action)) {
            try {
                int eventoId = Integer.parseInt(req.getParameter("eventoId"));
                boolean ok = eventoDAO.reclamarRecompensa(u.getId(), eventoId);
                if (ok) {
                    session.setAttribute("flashSuccess", "Recompensa acreditada a tu saldo exitosamente.");
                } else {
                    session.setAttribute("flashError", "No se pudo acreditar la recompensa.");
                }
            } catch (Exception e) {
                session.setAttribute("flashError", "Error al reclamar recompensa.");
            }
        } else if (esAdmin) {
            // Operaciones exclusivas de Administrador (CRUD)
            if ("crear".equals(action)) {
                try {
                    Evento nuevo = new Evento();
                    nuevo.setNombre(req.getParameter("nombre"));
                    nuevo.setDescripcion(req.getParameter("descripcion"));
                    nuevo.setLugar(req.getParameter("lugar"));
                    nuevo.setCategoria(req.getParameter("categoria"));
                    nuevo.setRecompensaDuts(Double.parseDouble(req.getParameter("recompensaDuts")));
                    nuevo.setCupos(Integer.parseInt(req.getParameter("cupos")));
                    nuevo.setEstado(req.getParameter("estado"));

                    String direccion = req.getParameter("direccion");
                    if (direccion != null && !direccion.trim().isEmpty()) {
                        nuevo.setDireccion(direccion.trim());
                    }
                    String universidad = req.getParameter("universidad");
                    if (universidad != null && !universidad.trim().isEmpty()) {
                        nuevo.setUniversidad(universidad.trim());
                    }
                    String imagenUrl = req.getParameter("imagenUrl");
                    if (imagenUrl != null && !imagenUrl.trim().isEmpty()) {
                        nuevo.setImagenUrl(imagenUrl.trim());
                    }

                    String fechaStr = req.getParameter("fecha"); // formato yyyy-MM-ddTHH:mm o yyyy-MM-dd
                    if (fechaStr != null && !fechaStr.isEmpty()) {
                        fechaStr = fechaStr.replace("T", " ");
                        if (fechaStr.length() == 16) fechaStr += ":00";
                        nuevo.setFecha(Timestamp.valueOf(fechaStr));
                    } else {
                        nuevo.setFecha(new Timestamp(System.currentTimeMillis()));
                    }

                    boolean ok = eventoDAO.crear(nuevo);
                    if (ok) {
                        session.setAttribute("flashSuccess", "Evento creado satisfactoriamente.");
                    } else {
                        session.setAttribute("flashError", "Error al registrar el evento en la base de datos.");
                    }
                } catch (Exception e) {
                    session.setAttribute("flashError", "Formato de datos inválido al crear evento: " + e.getMessage());
                }
            } else if ("actualizar".equals(action)) {
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    Evento mod = eventoDAO.obtenerPorId(id);
                    if (mod != null) {
                        mod.setNombre(req.getParameter("nombre"));
                        mod.setDescripcion(req.getParameter("descripcion"));
                        mod.setLugar(req.getParameter("lugar"));
                        mod.setCategoria(req.getParameter("categoria"));
                        mod.setRecompensaDuts(Double.parseDouble(req.getParameter("recompensaDuts")));
                        mod.setCupos(Integer.parseInt(req.getParameter("cupos")));
                        mod.setEstado(req.getParameter("estado"));

                        String direccion = req.getParameter("direccion");
                        if (direccion != null && !direccion.trim().isEmpty()) {
                            mod.setDireccion(direccion.trim());
                        }
                        String universidad = req.getParameter("universidad");
                        if (universidad != null && !universidad.trim().isEmpty()) {
                            mod.setUniversidad(universidad.trim());
                        }
                        String imagenUrl = req.getParameter("imagenUrl");
                        if (imagenUrl != null && !imagenUrl.trim().isEmpty()) {
                            mod.setImagenUrl(imagenUrl.trim());
                        }

                        String fechaStr = req.getParameter("fecha");
                        if (fechaStr != null && !fechaStr.isEmpty()) {
                            fechaStr = fechaStr.replace("T", " ");
                            if (fechaStr.length() == 16) fechaStr += ":00";
                            mod.setFecha(Timestamp.valueOf(fechaStr));
                        }

                        boolean ok = eventoDAO.actualizar(mod);
                        if (ok) {
                            session.setAttribute("flashSuccess", "Evento actualizado satisfactoriamente.");
                        } else {
                            session.setAttribute("flashError", "No se pudo actualizar el evento.");
                        }
                    }
                } catch (Exception e) {
                    session.setAttribute("flashError", "Error al actualizar evento: " + e.getMessage());
                }
            } else if ("eliminar".equals(action)) {
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    boolean ok = eventoDAO.eliminar(id);
                    if (ok) {
                        session.setAttribute("flashSuccess", "Evento eliminado de la base de datos.");
                    } else {
                        session.setAttribute("flashError", "No se pudo eliminar el evento.");
                    }
                } catch (Exception e) {
                    session.setAttribute("flashError", "Error al eliminar evento.");
                }
            }
        }

        resp.sendRedirect(req.getContextPath() + "/eventos");
    }
}
