package co.edu.uts.duts.listener;

import co.edu.uts.duts.util.DatabaseConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Enumeration;

/**
 * AppLifecycleListener: Administrador del ciclo de vida de la aplicación Web UTS DUTS.
 * Inicializa el pool de conexiones en el arranque y libera recursos y drivers JDBC
 * en el apagado para prevenir fugas de memoria (PermGen / Metaspace leaks) en Tomcat.
 */
@WebListener
public class AppLifecycleListener implements ServletContextListener {

    private static final Logger log = LoggerFactory.getLogger(AppLifecycleListener.class);

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        log.info("=================================================================");
        log.info("  INICIANDO PLATAFORMA UTS DUTS - ECOSISTEMA FINANCIERO DIGITAL  ");
        log.info("  Java Version: {} | VM: {}                                      ", 
                System.getProperty("java.version"), System.getProperty("java.vm.name"));
        log.info("  OS: {} {} | Arquitectura: {}                                  ", 
                System.getProperty("os.name"), System.getProperty("os.version"), System.getProperty("os.arch"));
        log.info("=================================================================");

        // Comprobación temprana de la base de datos (Fail-fast / Pre-warm)
        boolean dbOk = DatabaseConnection.testConnection();
        if (dbOk) {
            log.info("[OK] Pool HikariCP precalentado y comunicándose activamente con MySQL.");
        } else {
            log.warn("[AVISO] La base de datos aún no responde o está inicializando.");
        }

        // Atributos globales del contexto dinámicos desde .env
        sce.getServletContext().setAttribute("appNombre", co.edu.uts.duts.util.EnvConfig.get("APP_NAME", "Plataforma DUTS"));
        sce.getServletContext().setAttribute("appVersion", co.edu.uts.duts.util.EnvConfig.get("APP_VERSION", "2.4.0"));
        sce.getServletContext().setAttribute("institucion", co.edu.uts.duts.util.EnvConfig.get("INSTITUCION_NOMBRE", "Unidades Tecnológicas de Santander - UTS"));
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        log.info("Deteniendo Plataforma UTS DUTS. Liberando recursos...");

        // 1. Apagar pool HikariCP
        try {
            DatabaseConnection.shutdown();
        } catch (Exception e) {
            log.error("Error al apagar el pool de conexiones: {}", e.getMessage());
        }

        // 2. Desregistrar drivers JDBC para evitar fugas de memoria en Tomcat
        Enumeration<Driver> drivers = DriverManager.getDrivers();
        while (drivers.hasMoreElements()) {
            Driver driver = drivers.nextElement();
            try {
                DriverManager.deregisterDriver(driver);
                log.info("Driver JDBC desregistrado con éxito: {}", driver);
            } catch (SQLException e) {
                log.warn("No se pudo desregistrar el driver {}: {}", driver, e.getMessage());
            }
        }

        log.info("Plataforma UTS DUTS detenida correctamente.");
    }
}
