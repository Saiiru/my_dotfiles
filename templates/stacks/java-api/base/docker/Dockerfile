# Stage 1: build
FROM eclipse-temurin:17-jdk-alpine AS build
WORKDIR /workspace
COPY mvnw pom.xml ./
COPY .mvn .mvn
RUN ./mvnw -B -q dependency:go-offline
COPY src src
RUN ./mvnw -B -q package -DskipTests

# Stage 2: runtime
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
EXPOSE 8080
ENV SPRING_PROFILES_ACTIVE=prod
COPY --from=build /workspace/target/*.jar /app/app.jar
USER 1000
ENTRYPOINT ["java","-XX:MaxRAMPercentage=75.0","-XX:+UseG1GC","-XX:+UseContainerSupport","-jar","/app/app.jar"]
