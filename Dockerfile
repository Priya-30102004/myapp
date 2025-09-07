# Stage 1: build
FROM maven:3.8.8-openjdk-17 AS build
WORKDIR /workspace
COPY pom.xml .
COPY src ./src
RUN mvn -B -DskipTests clean package

# Stage 2: runtime
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
# copy jar from build stage (matches artifactId + version)
COPY --from=build /workspace/target/myapp-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]

