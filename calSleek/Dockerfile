FROM maven:3.8.5-openjdk-17 AS build

WORKDIR /app

COPY . .

RUN mvn -f calSleek/pom.xml clean package -DskipTests


FROM openjdk:17.0.1-jdk-slim

WORKDIR /app

COPY --from=build /app/calSleek/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","app.jar"]