package co.edu.uts.duts.model;

import java.io.Serializable;

/**
 * Clase base abstracta que demuestra el concepto de Abstracción en POO.
 * Proporciona atributos y contratos comunes para las entidades del modelo.
 */
public abstract class EntidadBase implements Serializable {
    private static final long serialVersionUID = 1L;

    protected int id;

    public EntidadBase() {
    }

    public EntidadBase(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    /**
     * Método abstracto que obliga a cada subclase a definir su propia 
     * representación de identificación única (Abstracción y Polimorfismo).
     */
    public abstract String getIdentificadorUnico();
}
