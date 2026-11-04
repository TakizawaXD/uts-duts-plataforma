package co.edu.uts.duts.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * DatabaseConnection: Proveedor centralizado y de alto rendimiento de conexiones JDBC
 * utilizando el pool de conexiones HikariCP. 
 * Optimiza la reutilización de sockets TCP, previene latencias y asegura reconexión automática.
 */
public final class DatabaseConnection {

    private static final Logger log = LoggerFactory.getLogger(DatabaseConnection.class);
    private static volatile HikariDataSource dataSource;
    private static final Object lock = new Object();

    private DatabaseConnection() {
        // Constructor privado para clase utilitaria estática
    }

    private static String getUrl() {
        String envUrl = System.getenv("DB_URL");
        if (envUrl != null && !envUrl.trim().isEmpty()) {
            return envUrl.trim();
        }
        return "jdbc:mysql://localhost:3306/duts?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8&allowPublicKeyRetrieval=true";
    }

    private static String getUser() {
        String envUser = System.getenv("DB_USER");
        if (envUser != null && !envUser.trim().isEmpty()) {
            return envUser.trim();
        }
        return "root";
    }

    private static String getPassword() {
        String envPass = System.getenv("DB_PASSWORD");
        if (envPass != null) {
            return envPass;
        }
        return "";
    }

    private static HikariDataSource getDataSource() {
        if (dataSource == null) {
            synchronized (lock) {
                if (dataSource == null) {
                    try {
                        HikariConfig config = new HikariConfig();
                        config.setDriverClassName("com.mysql.cj.jdbc.Driver");
                        config.setJdbcUrl(getUrl());
                        config.setUsername(getUser());
                        config.setPassword(getPassword());
                        config.setPoolName("HikariPool-UTS-DUTS");

                        // Tamaño y ciclo de vida del pool
                        config.setMaximumPoolSize(10);
                        config.setMinimumIdle(2);
                        config.setIdleTimeout(60000);         // 1 minuto
                        config.setConnectionTimeout(5000);    // 5 segundos de timeout
                        config.setMaxLifetime(1800000);       // 30 minutos

                        // Optimizaciones recomendadas por MySQL y HikariCP
                        config.addDataSourceProperty("cachePrepStmts", "true");
                        config.addDataSourceProperty("prepStmtCacheSize", "250");
                        config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");
                        config.addDataSourceProperty("useServerPrepStmts", "true");
                        config.addDataSourceProperty("useLocalSessionState", "true");
                        config.addDataSourceProperty("rewriteBatchedStatements", "true");
                        config.addDataSourceProperty("cacheResultSetMetadata", "true");
                        config.addDataSourceProperty("cacheServerConfiguration", "true");
                        config.addDataSourceProperty("elideSetAutoCommits", "true");
                        config.addDataSourceProperty("maintainTimeStats", "false");

                        dataSource = new HikariDataSource(config);
                        log.info("Pool de conexiones HikariCP inicializado exitosamente hacia: {}", getUrl());
                    } catch (Exception e) {
                        log.error("Fallo crítico inicializando el pool HikariCP: {}", e.getMessage(), e);
                        throw new RuntimeException("No se pudo iniciar el pool de conexiones a la base de datos.", e);
                    }
                }
            }
        }
        return dataSource;
    }

    /**
     * Obtiene una conexión activa del pool de conexiones HikariCP.
     * Al usar try-with-resources la conexión se devuelve al pool automáticamente.
     */
    public static Connection getConnection() throws SQLException {
        return getDataSource().getConnection();
    }

    /**
     * Realiza un healthcheck activo de la conexión con una consulta ligera.
     */
    public static boolean testConnection() {
        try (Connection con = getConnection();
             Statement stmt = con.createStatement()) {
            return stmt.execute("SELECT 1");
        } catch (Exception e) {
            log.warn("Healthcheck de conexión a BD fallido: {}", e.getMessage());
            return false;
        }
    }

    /**
     * Cierra el pool de conexiones de forma segura al apagar la aplicación.
     */
    public static void shutdown() {
        synchronized (lock) {
            if (dataSource != null && !dataSource.isClosed()) {
                log.info("Cerrando pool de conexiones HikariCP...");
                dataSource.close();
                dataSource = null;
            }
        }
    }
}
