package co.edu.uts.duts.model;

import java.sql.Timestamp;

public class Usuario extends EntidadBase {
    private String codigoEstudiantil;
    private String nombreCompleto;
    private String correo;
    private String username;
    private String passwordHash;
    private String programaAcademico;
    private int semestre;
    private int rolId;
    private Timestamp fechaRegistro;
    private String fotoPerfil;

    public Usuario() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getCodigoEstudiantil() { return codigoEstudiantil; }
    public void setCodigoEstudiantil(String codigoEstudiantil) { this.codigoEstudiantil = codigoEstudiantil; }
    
    public String getNombreCompleto() { return nombreCompleto; }
    public void setNombreCompleto(String nombreCompleto) { this.nombreCompleto = nombreCompleto; }
    
    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
    
    public String getProgramaAcademico() { return programaAcademico; }
    public void setProgramaAcademico(String programaAcademico) { this.programaAcademico = programaAcademico; }
    
    public int getSemestre() { return semestre; }
    public void setSemestre(int semestre) { this.semestre = semestre; }
    
    public int getRolId() { return rolId; }
    public void setRolId(int rolId) { this.rolId = rolId; }
    
    public Timestamp getFechaRegistro() { return fechaRegistro; }
    public void setFechaRegistro(Timestamp fechaRegistro) { this.fechaRegistro = fechaRegistro; }

    public String getFotoPerfil() {
        return (fotoPerfil != null && !fotoPerfil.trim().isEmpty() && !fotoPerfil.equals("avatar.jpg")) ? fotoPerfil : "default-avatar.svg";
    }
    public void setFotoPerfil(String fotoPerfil) {
        this.fotoPerfil = fotoPerfil;
    }

    @Override
    public String getIdentificadorUnico() {
        return "USR-" + (codigoEstudiantil != null ? codigoEstudiantil : String.valueOf(getId()));
    }
}
