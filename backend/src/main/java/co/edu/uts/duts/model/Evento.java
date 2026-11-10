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
    private String universidad;

    public String getImagenUrl() { 
        return (imagenUrl != null && !imagenUrl.trim().isEmpty()) ? imagenUrl : "https://images.unsplash.com/photo-1540575467063-178a50c2df87?auto=format&fit=crop&w=800&q=80"; 
    }
    public void setImagenUrl(String imagenUrl) { this.imagenUrl = imagenUrl; }

    public String getDireccion() { 
        return (direccion != null && !direccion.trim().isEmpty()) ? direccion : "Bucaramanga, Santander"; 
    }
    public void setDireccion(String direccion) { this.direccion = direccion; }

    public String getUniversidad() {
        return (universidad != null && !universidad.trim().isEmpty()) ? universidad : "UTS";
    }
    public void setUniversidad(String universidad) { this.universidad = universidad; }

    private String horaInicio;
    private String horaFin;
    private String modalidad;
    private String requisitos;

    public String getHoraInicio() {
        return (horaInicio != null && !horaInicio.trim().isEmpty()) ? horaInicio : "08:00 AM";
    }
    public void setHoraInicio(String horaInicio) { this.horaInicio = horaInicio; }

    public String getHoraFin() {
        return (horaFin != null && !horaFin.trim().isEmpty()) ? horaFin : "12:00 PM";
    }
    public void setHoraFin(String horaFin) { this.horaFin = horaFin; }

    public String getModalidad() {
        return (modalidad != null && !modalidad.trim().isEmpty()) ? modalidad : "Presencial";
    }
    public void setModalidad(String modalidad) { this.modalidad = modalidad; }

    public String getRequisitos() {
        return (requisitos != null && !requisitos.trim().isEmpty()) ? requisitos : "Carnet institucional vigente y documento de identidad";
    }
    public void setRequisitos(String requisitos) { this.requisitos = requisitos; }

    @Override
    public String getIdentificadorUnico() {
        return "EVT-" + getId();
    }
}
