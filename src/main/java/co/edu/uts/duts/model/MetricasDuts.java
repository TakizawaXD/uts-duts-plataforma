package co.edu.uts.duts.model;

import java.io.Serializable;

/**
 * Modelo de métricas financieras de DUTS para el estudiante.
 * Cumple con el requerimiento 2.3: "Calcular y mostrar el promedio de DUTS
 * por semana, mes, año y semestre" y el requisito de graduación de 70.000 DUTS.
 */
public class MetricasDuts implements Serializable {
    private static final long serialVersionUID = 1L;

    public static final double META_GRADUACION_DUTS = 70000.0;

    private double saldoActual;
    private double totalIngresos;
    private double totalEgresos;
    private double promedioSemanal;
    private double promedioMensual;
    private double promedioSemestral;
    private double promedioAnual;
    private double progresoGraduacion; // Porcentaje de 0 a 100%
    private double faltanteGraduacion;  // Cuánto falta para 70.000 DUTS
    private int semestreEstudiante;

    public MetricasDuts() {
    }

    public static MetricasDuts calcular(double saldo, double totalIngresos, double totalEgresos, int semestre) {
        MetricasDuts m = new MetricasDuts();
        m.saldoActual = saldo;
        m.totalIngresos = totalIngresos;
        m.totalEgresos = totalEgresos;
        m.semestreEstudiante = Math.max(1, semestre);

        // Requisito de graduación: 70.000 DUTS
        m.progresoGraduacion = Math.min(100.0, Math.max(0.0, (saldo / META_GRADUACION_DUTS) * 100.0));
        m.faltanteGraduacion = Math.max(0.0, META_GRADUACION_DUTS - saldo);

        // Base de cálculo: volumen de DUTS generados/acumulados
        double baseCalculo = Math.max(saldo, totalIngresos);

        // Promedio por semestre cursado
        m.promedioSemestral = baseCalculo / (double) m.semestreEstudiante;

        // Cada semestre académico tiene aproximadamente 4.5 a 6 meses (24 semanas)
        double totalMeses = Math.max(1.0, m.semestreEstudiante * 5.0);
        double totalSemanas = Math.max(1.0, m.semestreEstudiante * 20.0);
        double totalAnios = Math.max(0.5, m.semestreEstudiante / 2.0);

        m.promedioMensual = baseCalculo / totalMeses;
        m.promedioSemanal = baseCalculo / totalSemanas;
        m.promedioAnual = baseCalculo / totalAnios;

        return m;
    }

    public double getSaldoActual() {
        return saldoActual;
    }

    public double getTotalIngresos() {
        return totalIngresos;
    }

    public double getTotalEgresos() {
        return totalEgresos;
    }

    public double getPromedioSemanal() {
        return promedioSemanal;
    }

    public double getPromedioMensual() {
        return promedioMensual;
    }

    public double getPromedioSemestral() {
        return promedioSemestral;
    }

    public double getPromedioAnual() {
        return promedioAnual;
    }

    public double getProgresoGraduacion() {
        return progresoGraduacion;
    }

    public double getFaltanteGraduacion() {
        return faltanteGraduacion;
    }

    public double getMetaGraduacion() {
        return META_GRADUACION_DUTS;
    }

    public int getSemestreEstudiante() {
        return semestreEstudiante;
    }
}
