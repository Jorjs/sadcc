# ---- build ----
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /build

# deps first so this layer caches while only src changes
COPY pom.xml .
RUN mvn -B -q dependency:go-offline

COPY src ./src
RUN mvn -B -DskipTests clean package

# ---- runtime ----
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=build /build/target/my-app-*.jar ./app.jar
RUN adduser -S app
USER app
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
