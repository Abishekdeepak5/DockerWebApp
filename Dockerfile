# Use a base image with JDK and Maven installed
FROM maven:3.8.4-openjdk-17-slim AS builder

# Set the working directory
WORKDIR /app

# Copy the pom.xml file to the container
COPY pom.xml .

# Download dependencies defined in pom.xml
RUN mvn -B -f pom.xml -s /usr/share/maven/ref/settings-docker.xml dependency:resolve

# Copy the rest of the project to the container
COPY src ./src

# Build the application
RUN mvn -B -s /usr/share/maven/ref/settings-docker.xml package -DskipTests

# Use a lightweight base image with JRE only
FROM openjdk:17-slim

# Set the working directory
WORKDIR /app

# Copy the built JAR file from the previous stage
COPY --from=builder /app/target/demo.jar .

# Expose the port your app runs on
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "demo.jar"]
