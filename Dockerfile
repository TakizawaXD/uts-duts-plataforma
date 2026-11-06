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
COPY src ./src
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

# Iniciar servidor Tomcat adaptando dinámicamente el puerto si el entorno cloud inyecta $PORT (Render, Railway, Heroku)
CMD ["sh", "-c", "sed -i \"s/port=\\\"8080\\\"/port=\\\"${PORT:-8080}\\\"/g\" /usr/local/tomcat/conf/server.xml && catalina.sh run"]
