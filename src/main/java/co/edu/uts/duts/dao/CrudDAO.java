package co.edu.uts.duts.dao;

import java.util.List;

/**
 * Interfaz genérica que define el contrato de operaciones CRUD
 * demostrando el uso de Interfaces y Abstracción en Java.
 *
 * @param <T> Tipo de entidad administrada
 */
public interface CrudDAO<T> {
    boolean crear(T entidad);
    T obtenerPorId(int id);
    List<T> listarTodos();
    boolean actualizar(T entidad);
    boolean eliminar(int id);
}
