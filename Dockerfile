# syntax=docker/dockerfile:1

FROM eclipse-temurin:17-jdk-jammy AS build
WORKDIR /workspace

COPY APIGateway/ApiGateway/ ./APIGateway/ApiGateway/

WORKDIR /workspace/APIGateway/ApiGateway
RUN sed -i 's/\r$//' gradlew \
    && chmod +x gradlew \
    && ./gradlew clean bootJar --no-daemon

FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

RUN useradd --create-home --shell /usr/sbin/nologin spring
COPY --from=build /workspace/APIGateway/ApiGateway/build/libs/*.jar /app/app.jar

USER spring
EXPOSE 8084
ENTRYPOINT ["java", "-jar", "/app/app.jar"]

