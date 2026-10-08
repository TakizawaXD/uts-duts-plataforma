package co.edu.uts.duts.model;

import java.sql.Timestamp;

public class Evento extends EntidadBase {
    private String nombre;
    private String descripcion;
    private Timestamp fecha;
    private String lugar;
    private String categoria;
    private double recompensaDuts;
    private int cupos;
    private String estado;
    private boolean inscrito; // Indica si el usuario actual está inscrito

    public Evento() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public Timestamp getFecha() { return fecha; }
    public void setFecha(Timestamp fecha) { this.fecha = fecha; }

    public String getLugar() { return lugar; }
    public void setLugar(String lugar) { this.lugar = lugar; }

    public String getCategoria() { return categoria; }
    public void setCategoria(String categoria) { this.categoria = categoria; }

    public double getRecompensaDuts() { return recompensaDuts; }
    public void setRecompensaDuts(double recompensaDuts) { this.recompensaDuts = recompensaDuts; }

    public int getCupos() { return cupos; }
    public void setCupos(int cupos) { this.cupos = cupos; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public boolean isInscrito() { return inscrito; }
    public void setInscrito(boolean inscrito) { this.inscrito = inscrito; }

    private String imagenUrl;
    private String direccion;

    public String getImagenUrl() { 
        return (imagenUrl != null && !imagenUrl.trim().isEmpty()) ? imagenUrl : "evento_tecnologia.jpg"; 
    }
    public void setImagenUrl(String imagenUrl) { this.imagenUrl = imagenUrl; }

    public String getDireccion() { 
        return (direccion != null && !direccion.trim().isEmpty()) ? direccion : "Bucaramanga, Santander"; 
    }
    public void setDireccion(String direccion) { this.direccion = direccion; }

    @Override
    public String getIdentificadorUnico() {
        return "EVT-" + getId();
    }
}
