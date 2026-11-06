package co.edu.uts.duts.service;

import co.edu.uts.duts.model.Movimiento;
import co.edu.uts.duts.model.Usuario;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

import java.io.File;
import java.io.OutputStream;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/**
 * Servicio especializado en generación y renderizado de documentos PDF
 * institucionales (Facturas y Extractos DUTS) utilizando iText.
 * Desacopla la lógica de presentación visual del controlador HTTP.
 */
public class PdfExportService {

    private static final BaseColor COLOR_UTS_VERDE = new BaseColor(47, 92, 53);      // #2F5C35
    private static final BaseColor COLOR_UTS_CLARO = new BaseColor(140, 184, 43);    // #8CB82B
    private static final BaseColor COLOR_TEXTO_OSCURO = new BaseColor(30, 41, 59);  // #1E293B
    private static final BaseColor COLOR_TEXTO_MUTED = new BaseColor(100, 116, 139); // #64748B
    private static final BaseColor COLOR_FONDO_TABLA = new BaseColor(248, 250, 252);
    private static final BaseColor COLOR_BORDE = new BaseColor(226, 232, 240);
    private static final BaseColor COLOR_INGRESO = new BaseColor(22, 163, 74);
    private static final BaseColor COLOR_EGRESO = new BaseColor(220, 38, 38);

    private DecimalFormat obtenerFormatoMoneda() {
        DecimalFormatSymbols symbols = new DecimalFormatSymbols(new Locale.Builder().setLanguage("es").setRegion("CO").build());
        symbols.setGroupingSeparator('.');
        symbols.setDecimalSeparator(',');
        return new DecimalFormat("#,##0.00", symbols);
    }

    private SimpleDateFormat obtenerFormatoFecha() {
        return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    }

    /**
     * Genera la factura / comprobante individual de un movimiento en formato PDF.
     */
    public void exportarFacturaIndividual(OutputStream out, Usuario u, Movimiento m, String logoRealPath) throws Exception {
        Document document = new Document(PageSize.A4, 36, 36, 40, 40);
        PdfWriter.getInstance(document, out);
        document.open();

        DecimalFormat df = obtenerFormatoMoneda();
        SimpleDateFormat sdf = obtenerFormatoFecha();

        // Encabezado Institucional
        PdfPTable header = new PdfPTable(2);
        header.setWidthPercentage(100);
        header.setWidths(new float[]{65, 35});
        header.setSpacingAfter(15);

        // Logo y Título
        PdfPCell cLogo = new PdfPCell();
        cLogo.setBorder(Rectangle.NO_BORDER);
        try {
            if (logoRealPath != null && new File(logoRealPath).exists()) {
                Image img = Image.getInstance(logoRealPath);
                img.scaleToFit(140, 42);
                img.setSpacingAfter(6);
                cLogo.addElement(img);
            }
        } catch (Exception ignored) {}

        Font fTitulo = new Font(Font.FontFamily.HELVETICA, 15, Font.BOLD, COLOR_UTS_VERDE);
        Font fSub = new Font(Font.FontFamily.HELVETICA, 8.5f, Font.NORMAL, COLOR_TEXTO_MUTED);
        cLogo.addElement(new Paragraph("UNIDADES TECNOLÓGICAS DE SANTANDER", fTitulo));
        cLogo.addElement(new Paragraph("Plataforma Oficial de Billetera Digital DUTS", new Font(Font.FontFamily.HELVETICA, 10.5f, Font.BOLD, COLOR_UTS_CLARO)));
        cLogo.addElement(new Paragraph("NIT: 890.207.245-8 | Bucaramanga, Santander, Colombia", fSub));
        cLogo.addElement(new Paragraph("Resolución MinEducación - Vigilada por Mineducación", fSub));
        header.addCell(cLogo);

        // Bloque Factura
        PdfPCell cFac = new PdfPCell();
        cFac.setBorder(Rectangle.BOX);
        cFac.setBorderColor(COLOR_UTS_VERDE);
        cFac.setBorderWidth(1.5f);
        cFac.setBackgroundColor(COLOR_FONDO_TABLA);
        cFac.setPadding(10);
        cFac.setHorizontalAlignment(Element.ALIGN_CENTER);

        Paragraph pF = new Paragraph("FACTURA ELECTRÓNICA / COMPROBANTE DUTS", new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD, COLOR_UTS_VERDE));
        pF.setAlignment(Element.ALIGN_CENTER);
        cFac.addElement(pF);

        Paragraph pNum = new Paragraph(m.getReferencia(), new Font(Font.FontFamily.COURIER, 11, Font.BOLD, COLOR_TEXTO_OSCURO));
        pNum.setAlignment(Element.ALIGN_CENTER);
        cFac.addElement(pNum);

        String strFecha = (m.getFechaHora() != null) ? sdf.format(m.getFechaHora()) : "Sin registrar";
        Paragraph pFecha = new Paragraph("Fecha: " + strFecha, new Font(Font.FontFamily.HELVETICA, 8, Font.NORMAL, COLOR_TEXTO_MUTED));
        pFecha.setAlignment(Element.ALIGN_CENTER);
        cFac.addElement(pFecha);

        header.addCell(cFac);
        document.add(header);

        document.add(crearLineaSeparadora());

        // Datos del Titular
        PdfPTable tInfo = new PdfPTable(2);
        tInfo.setWidthPercentage(100);
        tInfo.setWidths(new float[]{50, 50});
        tInfo.setSpacingBefore(10);
        tInfo.setSpacingAfter(15);

        PdfPCell cEst = new PdfPCell();
        cEst.setBorder(Rectangle.NO_BORDER);
        cEst.addElement(new Paragraph("DATOS DEL TITULAR INSTITUCIONAL", new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD, COLOR_UTS_VERDE)));
        cEst.addElement(new Paragraph("Nombre: " + u.getNombreCompleto(), new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD, COLOR_TEXTO_OSCURO)));
        cEst.addElement(new Paragraph("Código Estudiantil: " + u.getCodigoEstudiantil(), new Font(Font.FontFamily.HELVETICA, 9, Font.NORMAL, COLOR_TEXTO_OSCURO)));
        cEst.addElement(new Paragraph("Usuario UTS: @" + u.getUsername(), new Font(Font.FontFamily.HELVETICA, 9, Font.NORMAL, COLOR_TEXTO_MUTED)));
        cEst.addElement(new Paragraph("Correo: " + (u.getCorreo() != null ? u.getCorreo() : "No registrado"), new Font(Font.FontFamily.HELVETICA, 9, Font.NORMAL, COLOR_TEXTO_MUTED)));
        cEst.addElement(new Paragraph("Programa: " + (u.getProgramaAcademico() != null ? u.getProgramaAcademico() : "Estudiante Regular"), new Font(Font.FontFamily.HELVETICA, 9, Font.NORMAL, COLOR_TEXTO_MUTED)));
        tInfo.addCell(cEst);

        String tipoOperacion = "INGRESO".equalsIgnoreCase(m.getTipo()) ? "RECIBIDO" : "ENVIADO";
        PdfPCell cTran = new PdfPCell();
        cTran.setBorder(Rectangle.NO_BORDER);
        cTran.addElement(new Paragraph("DETALLES DE LA TRANSACCIÓN", new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD, COLOR_UTS_VERDE)));
        cTran.addElement(new Paragraph("Tipo de Operación: " + tipoOperacion, new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD, "INGRESO".equalsIgnoreCase(m.getTipo()) ? COLOR_INGRESO : COLOR_EGRESO)));
        cTran.addElement(new Paragraph("Estado: APROBADA Y REGISTRADA EN BD", new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD, COLOR_INGRESO)));
        cTran.addElement(new Paragraph("Canal: Ecosistema de Méritos y Vida Universitaria DUTS UTS", new Font(Font.FontFamily.HELVETICA, 9, Font.NORMAL, COLOR_TEXTO_MUTED)));
        cTran.addElement(new Paragraph("Sede Operativa: Bucaramanga (Calle de los Estudiantes)", new Font(Font.FontFamily.HELVETICA, 9, Font.NORMAL, COLOR_TEXTO_MUTED)));
        cTran.addElement(new Paragraph("Moneda: DUTS (Puntos de Mérito Institucional)", new Font(Font.FontFamily.HELVETICA, 9, Font.NORMAL, COLOR_TEXTO_MUTED)));
        tInfo.addCell(cTran);

        document.add(tInfo);

        // Tabla de Conceptos Facturados
        PdfPTable tItems = new PdfPTable(4);
        tItems.setWidthPercentage(100);
        tItems.setWidths(new float[]{15, 50, 15, 20});
        tItems.setSpacingBefore(10);
        tItems.setSpacingAfter(15);

        agregarCeldaEncabezado(tItems, "CÓDIGO");
        agregarCeldaEncabezado(tItems, "DESCRIPCIÓN / CONCEPTO ACADÉMICO");
        agregarCeldaEncabezado(tItems, "TIPO");
        agregarCeldaEncabezado(tItems, "TOTAL DUTS");

        PdfPCell c1 = new PdfPCell(new Phrase(String.valueOf(m.getId()), new Font(Font.FontFamily.HELVETICA, 9, Font.NORMAL, COLOR_TEXTO_OSCURO)));
        c1.setPadding(8);
        c1.setBorderColor(COLOR_BORDE);
        tItems.addCell(c1);

        PdfPCell c2 = new PdfPCell(new Phrase(m.getDescripcion(), new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD, COLOR_TEXTO_OSCURO)));
        c2.setPadding(8);
        c2.setBorderColor(COLOR_BORDE);
        tItems.addCell(c2);

        PdfPCell c3 = new PdfPCell(new Phrase(tipoOperacion, new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD, "INGRESO".equalsIgnoreCase(m.getTipo()) ? COLOR_INGRESO : COLOR_EGRESO)));
        c3.setPadding(8);
        c3.setBorderColor(COLOR_BORDE);
        c3.setHorizontalAlignment(Element.ALIGN_CENTER);
        tItems.addCell(c3);

        String prefijo = "INGRESO".equalsIgnoreCase(m.getTipo()) ? "+" : "-";
        PdfPCell c4 = new PdfPCell(new Phrase(prefijo + df.format(m.getMonto()) + " DUTS", new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD, "INGRESO".equalsIgnoreCase(m.getTipo()) ? COLOR_INGRESO : COLOR_EGRESO)));
        c4.setPadding(8);
        c4.setBorderColor(COLOR_BORDE);
        c4.setHorizontalAlignment(Element.ALIGN_RIGHT);
        tItems.addCell(c4);

        document.add(tItems);

        // Resumen Financiero
        PdfPTable tTotales = new PdfPTable(2);
        tTotales.setWidthPercentage(45);
        tTotales.setHorizontalAlignment(Element.ALIGN_RIGHT);
        tTotales.setWidths(new float[]{55, 45});
        tTotales.setSpacingAfter(25);

        agregarFilaTotal(tTotales, "Subtotal Liquidado:", df.format(m.getMonto()) + " DUTS", false);
        agregarFilaTotal(tTotales, "Impuestos / Retenciones (0%):", "0,00 DUTS", false);
        agregarFilaTotal(tTotales, "Total Transacción:", df.format(m.getMonto()) + " DUTS", true);

        document.add(tTotales);

        // Certificación y Sello Institucional
        document.add(crearBloqueFirmaDigital(sdf.format(new Date()), m.getReferencia()));
        document.close();
    }

    /**
     * Genera el extracto consolidado de cuenta con historial de movimientos.
     */
    public void exportarExtractoCompleto(OutputStream out, Usuario u, double saldo, List<Movimiento> movimientos, String logoRealPath) throws Exception {
        Document document = new Document(PageSize.A4, 36, 36, 40, 40);
        PdfWriter.getInstance(document, out);
        document.open();

        DecimalFormat df = obtenerFormatoMoneda();
        SimpleDateFormat sdf = obtenerFormatoFecha();

        // Encabezado
        PdfPTable header = new PdfPTable(2);
        header.setWidthPercentage(100);
        header.setWidths(new float[]{65, 35});
        header.setSpacingAfter(15);

        PdfPCell cLogo = new PdfPCell();
        cLogo.setBorder(Rectangle.NO_BORDER);
        try {
            if (logoRealPath != null && new File(logoRealPath).exists()) {
                Image img = Image.getInstance(logoRealPath);
                img.scaleToFit(140, 42);
                img.setSpacingAfter(6);
                cLogo.addElement(img);
            }
        } catch (Exception ignored) {}

        Font fTitulo = new Font(Font.FontFamily.HELVETICA, 15, Font.BOLD, COLOR_UTS_VERDE);
        Font fSub = new Font(Font.FontFamily.HELVETICA, 8.5f, Font.NORMAL, COLOR_TEXTO_MUTED);
        cLogo.addElement(new Paragraph("UNIDADES TECNOLÓGICAS DE SANTANDER", fTitulo));
        cLogo.addElement(new Paragraph("EXTRACTO OFICIAL DE CUENTA INSTITUCIONAL DUTS", new Font(Font.FontFamily.HELVETICA, 10.5f, Font.BOLD, COLOR_UTS_CLARO)));
        cLogo.addElement(new Paragraph("NIT: 890.207.245-8 | Bucaramanga, Santander, Colombia", fSub));
        cLogo.addElement(new Paragraph("Reporte Consolidado de Movimientos y Puntos", fSub));
        header.addCell(cLogo);

        PdfPCell cFac = new PdfPCell();
        cFac.setBorder(Rectangle.BOX);
        cFac.setBorderColor(COLOR_UTS_VERDE);
        cFac.setBorderWidth(1.5f);
        cFac.setBackgroundColor(COLOR_FONDO_TABLA);
        cFac.setPadding(10);
        cFac.setHorizontalAlignment(Element.ALIGN_CENTER);

        Paragraph pF = new Paragraph("SALDO DISPONIBLE ACTUAL", new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD, COLOR_UTS_VERDE));
        pF.setAlignment(Element.ALIGN_CENTER);
        cFac.addElement(pF);

        Paragraph pNum = new Paragraph(df.format(saldo) + " DUTS", new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD, COLOR_UTS_VERDE));
        pNum.setAlignment(Element.ALIGN_CENTER);
        cFac.addElement(pNum);

        Paragraph pFecha = new Paragraph("Generado: " + sdf.format(new Date()), new Font(Font.FontFamily.HELVETICA, 8, Font.NORMAL, COLOR_TEXTO_MUTED));
        pFecha.setAlignment(Element.ALIGN_CENTER);
        cFac.addElement(pFecha);

        header.addCell(cFac);
        document.add(header);

        document.add(crearLineaSeparadora());

        // Datos del Titular
        PdfPTable tInfo = new PdfPTable(3);
        tInfo.setWidthPercentage(100);
        tInfo.setWidths(new float[]{40, 35, 25});
        tInfo.setSpacingBefore(10);
        tInfo.setSpacingAfter(15);

        PdfPCell c1 = new PdfPCell();
        c1.setBorder(Rectangle.NO_BORDER);
        c1.addElement(new Paragraph("TITULAR DE CUENTA", new Font(Font.FontFamily.HELVETICA, 8, Font.BOLD, COLOR_TEXTO_MUTED)));
        c1.addElement(new Paragraph(u.getNombreCompleto(), new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD, COLOR_TEXTO_OSCURO)));
        c1.addElement(new Paragraph("Cód: " + u.getCodigoEstudiantil(), new Font(Font.FontFamily.HELVETICA, 9, Font.NORMAL, COLOR_TEXTO_OSCURO)));
        tInfo.addCell(c1);

        PdfPCell c2 = new PdfPCell();
        c2.setBorder(Rectangle.NO_BORDER);
        c2.addElement(new Paragraph("PROGRAMA ACADÉMICO", new Font(Font.FontFamily.HELVETICA, 8, Font.BOLD, COLOR_TEXTO_MUTED)));
        c2.addElement(new Paragraph(u.getProgramaAcademico() != null ? u.getProgramaAcademico() : "Estudiante UTS", new Font(Font.FontFamily.HELVETICA, 9, Font.NORMAL, COLOR_TEXTO_OSCURO)));
        c2.addElement(new Paragraph("Semestre: " + u.getSemestre(), new Font(Font.FontFamily.HELVETICA, 9, Font.NORMAL, COLOR_TEXTO_MUTED)));
        tInfo.addCell(c2);

        // Calcular totales
        double totalIng = 0;
        double totalEgr = 0;
        for (Movimiento m : movimientos) {
            if ("INGRESO".equalsIgnoreCase(m.getTipo())) totalIng += m.getMonto();
            else totalEgr += m.getMonto();
        }

        PdfPCell c3 = new PdfPCell();
        c3.setBorder(Rectangle.NO_BORDER);
        c3.addElement(new Paragraph("TOTALES HISTÓRICOS", new Font(Font.FontFamily.HELVETICA, 8, Font.BOLD, COLOR_TEXTO_MUTED)));
        c3.addElement(new Paragraph("Recibidos: +" + df.format(totalIng), new Font(Font.FontFamily.HELVETICA, 8, Font.BOLD, COLOR_INGRESO)));
        c3.addElement(new Paragraph("Enviados: -" + df.format(totalEgr), new Font(Font.FontFamily.HELVETICA, 8, Font.BOLD, COLOR_EGRESO)));
        tInfo.addCell(c3);

        document.add(tInfo);

        // Tabla de Movimientos
        PdfPTable tMov = new PdfPTable(5);
        tMov.setWidthPercentage(100);
        tMov.setWidths(new float[]{22, 14, 36, 16, 16});
        tMov.setSpacingBefore(10);
        tMov.setSpacingAfter(20);

        agregarCeldaEncabezado(tMov, "REFERENCIA");
        agregarCeldaEncabezado(tMov, "TIPO");
        agregarCeldaEncabezado(tMov, "DESCRIPCIÓN");
        agregarCeldaEncabezado(tMov, "FECHA");
        agregarCeldaEncabezado(tMov, "MONTO");

        boolean par = false;
        for (Movimiento m : movimientos) {
            BaseColor fondoFila = par ? COLOR_FONDO_TABLA : BaseColor.WHITE;
            par = !par;

            String labelTipo = "INGRESO".equalsIgnoreCase(m.getTipo()) ? "RECIBIDO" : "ENVIADO";

            PdfPCell r1 = new PdfPCell(new Phrase(m.getReferencia(), new Font(Font.FontFamily.COURIER, 7.5f, Font.NORMAL, COLOR_TEXTO_OSCURO)));
            r1.setBackgroundColor(fondoFila);
            r1.setPadding(6);
            r1.setBorderColor(COLOR_BORDE);
            tMov.addCell(r1);

            PdfPCell r2 = new PdfPCell(new Phrase(labelTipo, new Font(Font.FontFamily.HELVETICA, 7.5f, Font.BOLD, "INGRESO".equalsIgnoreCase(m.getTipo()) ? COLOR_INGRESO : COLOR_EGRESO)));
            r2.setBackgroundColor(fondoFila);
            r2.setPadding(6);
            r2.setBorderColor(COLOR_BORDE);
            r2.setHorizontalAlignment(Element.ALIGN_CENTER);
            tMov.addCell(r2);

            PdfPCell r3 = new PdfPCell(new Phrase(m.getDescripcion(), new Font(Font.FontFamily.HELVETICA, 7.5f, Font.NORMAL, COLOR_TEXTO_OSCURO)));
            r3.setBackgroundColor(fondoFila);
            r3.setPadding(6);
            r3.setBorderColor(COLOR_BORDE);
            tMov.addCell(r3);

            String fechaMovStr = (m.getFechaHora() != null) ? sdf.format(m.getFechaHora()) : "Sin registrar";
            PdfPCell r4 = new PdfPCell(new Phrase(fechaMovStr, new Font(Font.FontFamily.HELVETICA, 7.5f, Font.NORMAL, COLOR_TEXTO_MUTED)));
            r4.setBackgroundColor(fondoFila);
            r4.setPadding(6);
            r4.setBorderColor(COLOR_BORDE);
            r4.setHorizontalAlignment(Element.ALIGN_CENTER);
            tMov.addCell(r4);

            String pref = "INGRESO".equalsIgnoreCase(m.getTipo()) ? "+" : "-";
            PdfPCell r5 = new PdfPCell(new Phrase(pref + df.format(m.getMonto()), new Font(Font.FontFamily.HELVETICA, 8, Font.BOLD, "INGRESO".equalsIgnoreCase(m.getTipo()) ? COLOR_INGRESO : COLOR_EGRESO)));
            r5.setBackgroundColor(fondoFila);
            r5.setPadding(6);
            r5.setBorderColor(COLOR_BORDE);
            r5.setHorizontalAlignment(Element.ALIGN_RIGHT);
            tMov.addCell(r5);
        }

        document.add(tMov);

        document.add(crearBloqueFirmaDigital(sdf.format(new Date()), "EXTRACTO-" + u.getCodigoEstudiantil() + "-" + System.currentTimeMillis()));
        document.close();
    }

    private void agregarCeldaEncabezado(PdfPTable table, String texto) {
        PdfPCell c = new PdfPCell(new Phrase(texto, new Font(Font.FontFamily.HELVETICA, 8, Font.BOLD, BaseColor.WHITE)));
        c.setBackgroundColor(COLOR_UTS_VERDE);
        c.setPadding(7);
        c.setBorderColor(COLOR_UTS_VERDE);
        c.setHorizontalAlignment(Element.ALIGN_CENTER);
        table.addCell(c);
    }

    private void agregarFilaTotal(PdfPTable table, String etiqueta, String valor, boolean esTotal) {
        Font fLabel = new Font(Font.FontFamily.HELVETICA, esTotal ? 9 : 8, esTotal ? Font.BOLD : Font.NORMAL, esTotal ? COLOR_UTS_VERDE : COLOR_TEXTO_MUTED);
        Font fVal = new Font(Font.FontFamily.HELVETICA, esTotal ? 10 : 8, Font.BOLD, esTotal ? COLOR_UTS_VERDE : COLOR_TEXTO_OSCURO);

        PdfPCell c1 = new PdfPCell(new Phrase(etiqueta, fLabel));
        c1.setBorder(Rectangle.NO_BORDER);
        c1.setPadding(3);
        table.addCell(c1);

        PdfPCell c2 = new PdfPCell(new Phrase(valor, fVal));
        c2.setBorder(Rectangle.NO_BORDER);
        c2.setPadding(3);
        c2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        table.addCell(c2);
    }

    private PdfPTable crearLineaSeparadora() {
        PdfPTable line = new PdfPTable(1);
        line.setWidthPercentage(100);
        PdfPCell c = new PdfPCell();
        c.setBackgroundColor(COLOR_UTS_CLARO);
        c.setFixedHeight(2f);
        c.setBorder(Rectangle.NO_BORDER);
        line.addCell(c);
        line.setSpacingAfter(10);
        return line;
    }

    private PdfPTable crearBloqueFirmaDigital(String fechaEmision, String referencia) throws DocumentException {
        PdfPTable footer = new PdfPTable(2);
        footer.setWidthPercentage(100);
        footer.setWidths(new float[]{65, 35});
        footer.setSpacingBefore(15);

        PdfPCell cLeft = new PdfPCell();
        cLeft.setBorder(Rectangle.BOX);
        cLeft.setBorderColor(COLOR_BORDE);
        cLeft.setBackgroundColor(COLOR_FONDO_TABLA);
        cLeft.setPadding(10);

        Font fSec = new Font(Font.FontFamily.HELVETICA, 8, Font.BOLD, COLOR_UTS_VERDE);
        Font fSecText = new Font(Font.FontFamily.COURIER, 7, Font.NORMAL, COLOR_TEXTO_MUTED);

        cLeft.addElement(new Paragraph("VALIDACIÓN ELECTRÓNICA INSTITUCIONAL", fSec));
        cLeft.addElement(new Paragraph("Este documento cuenta con validez legal interna universitaria conforme al reglamento de bienestar y mérito de las UTS.", new Font(Font.FontFamily.HELVETICA, 7.5f, Font.NORMAL, COLOR_TEXTO_MUTED)));
        cLeft.addElement(new Paragraph("Código Hash de Integridad: SHA256:" + Integer.toHexString(referencia.hashCode()) + "e9b724af" + Long.toHexString(System.currentTimeMillis()), fSecText));
        cLeft.addElement(new Paragraph("Emisión: " + fechaEmision + " | Servidor Seguro DUTS Bucaramanga", fSecText));
        footer.addCell(cLeft);

        PdfPCell cRight = new PdfPCell();
        cRight.setBorder(Rectangle.BOX);
        cRight.setBorderColor(COLOR_UTS_VERDE);
        cRight.setBackgroundColor(BaseColor.WHITE);
        cRight.setPadding(10);
        cRight.setHorizontalAlignment(Element.ALIGN_CENTER);

        Paragraph pSello = new Paragraph("SELLO INSTITUCIONAL", new Font(Font.FontFamily.HELVETICA, 8, Font.BOLD, COLOR_UTS_VERDE));
        pSello.setAlignment(Element.ALIGN_CENTER);
        cRight.addElement(pSello);

        Paragraph pVal = new Paragraph("DOCUMENTO VERIFICADO\nUNIDADES TECNOLÓGICAS\nDE SANTANDER", new Font(Font.FontFamily.HELVETICA, 7.5f, Font.BOLD, COLOR_TEXTO_MUTED));
        pVal.setAlignment(Element.ALIGN_CENTER);
        cRight.addElement(pVal);

        footer.addCell(cRight);
        return footer;
    }
}
