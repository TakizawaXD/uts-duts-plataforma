package co.edu.uts.duts.model;

import java.sql.Timestamp;

public class Movimiento extends EntidadBase {
    private int cuentaId;
    private String tipo; // INGRESO o EGRESO
    private double monto;
    private String descripcion;
    private String referencia;
    private Timestamp fechaHora;

    public Movimiento() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getCuentaId() { return cuentaId; }
    public void setCuentaId(int cuentaId) { this.cuentaId = cuentaId; }

    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }

    public double getMonto() { return monto; }
    public void setMonto(double monto) { this.monto = monto; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public String getReferencia() { return referencia; }
    public void setReferencia(String referencia) { this.referencia = referencia; }

    public Timestamp getFechaHora() { return fechaHora; }
    public void setFechaHora(Timestamp fechaHora) { this.fechaHora = fechaHora; }

    @Override
    public String getIdentificadorUnico() {
        return (referencia != null && !referencia.trim().isEmpty()) ? referencia : "MOV-" + getId();
    }
}
