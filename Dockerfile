# ==========================================
# ETAPA 1: Construcción con Maven y Java 21
# ==========================================
FROM maven:3.9-eclipse-temurin-21 AS builder
WORKDIR /app

# Copiar configuración de dependencias
COPY pom.xml .

# Descargar dependencias en caché
RUN mvn dependency:go-offline -B || true

# Copiar código fuente y compilar empaquetado WAR
COPY backend ./backend
COPY frontend ./frontend
RUN mvn clean package -DskipTests

# ==========================================
# ETAPA 2: Servidor Apache Tomcat 9 con Java 21
# ==========================================
FROM tomcat:9.0-jdk21-temurin

# Limpiar aplicaciones de ejemplo por defecto de Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copiar el archivo WAR como ROOT para que responda en la raíz /
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Exponer puerto por defecto
EXPOSE 8080

# Deshabilitar puerto TCP de apagado (8005) para evitar conflictos con balanceadores cloud
# y adaptar dinámicamente el conector HTTP al puerto asignado por Render ($PORT)
CMD ["sh", "-c", "sed -i 's/port=\"8005\"/port=\"-1\"/g' /usr/local/tomcat/conf/server.xml && sed -i \"s/port=\\\"8080\\\"/port=\\\"${PORT:-8080}\\\"/g\" /usr/local/tomcat/conf/server.xml && catalina.sh run"]
