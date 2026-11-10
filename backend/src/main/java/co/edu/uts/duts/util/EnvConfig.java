package co.edu.uts.duts.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

/**
 * EnvConfig: Administrador centralizado de variables de entorno y configuración.
 * 
 * Prioridad de resolución:
 * 1. Variables de entorno del Sistema Operativo / Hosting (System.getenv)
 * 2. Propiedades de la JVM (System.getProperty)
 * 3. Archivo local .env (en raíz de ejecución o directorios padres)
 * 4. Valor por defecto suministrado
 */
public final class EnvConfig {

    private static final Logger log = LoggerFactory.getLogger(EnvConfig.class);
    private static final Map<String, String> dotEnvMap = new HashMap<>();
    private static boolean loaded = false;

    static {
        loadDotEnv();
    }

    private EnvConfig() {
    }

    private static synchronized void loadDotEnv() {
        if (loaded) return;
        loaded = true;

        // Intentar ubicar el archivo .env en diferentes rutas contextuales
        File envFile = findDotEnvFile();
        if (envFile == null || !envFile.exists() || !envFile.isFile()) {
            log.info("No se encontro archivo .env local. Se usaran variables de entorno del sistema.");
            return;
        }

        log.info("Cargando variables de entorno desde: {}", envFile.getAbsolutePath());
        try (BufferedReader reader = new BufferedReader(new FileReader(envFile, StandardCharsets.UTF_8))) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                // Ignorar líneas vacías y comentarios
                if (line.isEmpty() || line.startsWith("#")) {
                    continue;
                }

                int eqIdx = line.indexOf('=');
                if (eqIdx <= 0) {
                    continue;
                }

                String key = line.substring(0, eqIdx).trim();
                String val = line.substring(eqIdx + 1).trim();

                // Remover comillas envolventes si existen ("valor" o 'valor')
                if (val.length() >= 2 && 
                    ((val.startsWith("\"") && val.endsWith("\"")) || (val.startsWith("'") && val.endsWith("'")))) {
                    val = val.substring(1, val.length() - 1);
                }

                dotEnvMap.put(key, val);
            }
            log.info("Se cargaron {} variables desde el archivo .env", dotEnvMap.size());
        } catch (IOException e) {
            log.warn("Error leyendo archivo .env: {}", e.getMessage());
        }
    }

    private static File findDotEnvFile() {
        // 1. Directorio de trabajo actual
        File current = new File(".env");
        if (current.exists()) return current;

        // 2. Directorio user.dir
        String userDir = System.getProperty("user.dir");
        if (userDir != null) {
            File inUserDir = new File(userDir, ".env");
            if (inUserDir.exists()) return inUserDir;

            // 3. Directorio padre (si se ejecuta desde submódulo o target)
            File parent = new File(userDir).getParentFile();
            if (parent != null) {
                File inParent = new File(parent, ".env");
                if (inParent.exists()) return inParent;
            }
        }

        return null;
    }

    /**
     * Obtiene una variable por clave o null si no existe.
     */
    public static String get(String key) {
        return get(key, null);
    }

    /**
     * Obtiene una variable con valor por defecto.
     */
    public static String get(String key, String defaultValue) {
        if (key == null) return defaultValue;

        // 1. Sistema Operativo / Plataforma de Hosting (Render, Railway, etc.)
        String sysEnv = System.getenv(key);
        if (sysEnv != null && !sysEnv.trim().isEmpty()) {
            return sysEnv.trim();
        }

        // 2. Propiedad JVM
        String sysProp = System.getProperty(key);
        if (sysProp != null && !sysProp.trim().isEmpty()) {
            return sysProp.trim();
        }

        // 3. Archivo .env
        String dotEnvVal = dotEnvMap.get(key);
        if (dotEnvVal != null && !dotEnvVal.trim().isEmpty()) {
            return dotEnvVal.trim();
        }

        return defaultValue;
    }

    /**
     * Obtiene una variable numérica entera.
     */
    public static int getInt(String key, int defaultValue) {
        String val = get(key);
        if (val == null) return defaultValue;
        try {
            return Integer.parseInt(val.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    /**
     * Obtiene una variable booleana.
     */
    public static boolean getBoolean(String key, boolean defaultValue) {
        String val = get(key);
        if (val == null) return defaultValue;
        return Boolean.parseBoolean(val.trim());
    }
}
