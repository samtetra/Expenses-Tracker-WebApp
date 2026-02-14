#----Stage-1.Jar builder-----
FROM maven:3.9.12-eclipse-temurin-21 AS builder
WORKDIR /app
COPY . .
# Build application and skip test cases
RUN mvn clean package -DskipTests

#----stage-2-------
FROM eclipse-temurin:21-jre-alpine-3.23
WORKDIR /app
# Copy build from stage 1 (builder)
COPY --from=builder /app/target/*.jar expenseapp.jar
EXPOSE 8080
# Start the application
CMD ["java","-jar","expenseapp.jar"]

