# Docker Image Building Guide

Build Docker images for your Spring application before deploying to Kubernetes.

## Prerequisites
- Docker installed and running
- Dockerfile prepared

## Building Docker Images

### Spring Application
```bash
# Build Spring application image
docker build -t spring-app:latest -f Dockerfile.spring .

# Tag with version
docker build -t spring-app:v1.0 -f Dockerfile.spring .
```

## Loading Images into minikube

### Option 1: Build directly in minikube Docker

This is the easiest method:

```bash
# Set Docker environment to use minikube's Docker daemon
eval $(minikube docker-env)

# Build image (it'll be directly available in minikube)
docker build -t spring-app:latest -f Dockerfile.spring .

# Reset Docker environment when done
eval $(minikube docker-env -u)
```

### Option 2: Load pre-built images
```bash
# Load image into minikube
minikube image load spring-app:latest
```

### Option 3: Use image registry
Push to Docker Hub:

```bash
# Tag image
docker tag spring-app:latest your-username/spring-app:latest

# Push to registry
docker push your-username/spring-app:latest

# Update deployment manifest to use: your-username/spring-app:latest
```

## Verifying Images in minikube

```bash
# List all images in minikube
minikube image ls

# Should show:
# spring-app:latest
```

## Example Dockerfile

### Dockerfile.spring
```dockerfile
FROM maven:3.9-eclipse-temurin-21 as builder
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=builder /app/target/app.jar application.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "application.jar"]
```

### Using Gradle
```dockerfile
FROM gradle:7.6-jdk21 as builder
WORKDIR /app
COPY . .
RUN gradle build -x test

FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=builder /app/build/libs/*.jar application.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "application.jar"]
```

## Troubleshooting

**Image not found in Kubernetes:**
```bash
# Ensure imagePullPolicy is set to Never in deployment manifests
# when using images built locally in minikube

# Check if image exists
minikube image ls | grep spring-app

# If missing, rebuild or load the image
```

**Out of disk space in minikube:**
```bash
# Clean up old images
minikube image rm <image-name>

# Or delete and recreate minikube cluster
minikube delete
minikube start --memory=4096 --cpus=2 --driver=docker
```

**Building fails with Maven/Gradle:**
```bash
# Make sure your pom.xml or build.gradle is valid
# Check you have Java 21 installed locally
# Or build in minikube Docker directly (see Option 1)
```
