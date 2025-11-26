# ============================
# Stage 1: Build (Maven + JDK)
# ============================
FROM eclipse-temurin:21-jdk-alpine AS build

WORKDIR /workspace

# Copia apenas o necessário para cachear dependências
COPY mvnw pom.xml ./
COPY .mvn .mvn

# Baixa dependências para cache
RUN ./mvnw -B -q dependency:go-offline

# Copia o código-fonte e empacota
COPY src src
RUN ./mvnw -B -q package -DskipTests

# =============================
# Stage 2: Runtime (JRE slim)
# =============================
FROM eclipse-temurin:21-jre-alpine AS runtime

# Usuário não-root
RUN addgroup -S app && adduser -S app -G app

WORKDIR /app

# Porta padrão
EXPOSE 8080

# Perfil padrão
ENV SPRING_PROFILES_ACTIVE=prod

# Copia o jar do build
COPY --from=build /workspace/target/*.jar /app/app.jar

# Permissões
RUN chown -R app:app /app
USER app

# JVM flags adequadas para container
ENTRYPOINT ["java", \
  "-XX:MaxRAMPercentage=75.0", \
  "-XX:+UseG1GC", \
  "-XX:+UseContainerSupport", \
  "-jar", "/app/app.jar"]
