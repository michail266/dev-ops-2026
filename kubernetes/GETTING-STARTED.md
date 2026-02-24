# Kubernetes Getting Started Guide

Simple Kubernetes setup for **Linux** using **minikube** and **kubectl**.

## Prerequisites

### System Requirements
- **RAM**: 8GB minimum
- **CPU**: 2+ cores
- **Disk**: 20GB free space
- **OS**: Linux (Ubuntu, Debian, CentOS, etc.)

### Install Docker

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y docker.io
sudo usermod -aG docker $USER
# Log out and back in, or:
newgrp docker

# Verify
docker --version
docker ps
```

## Step 1: Install Tools

The setup script installs these automatically, but you can also install manually:

```bash
# Install minikube
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

# Verify
minikube version
kubectl version --client
```

## Step 2: Build Docker Images

Build your Spring application image:

```bash
# Build Spring app
docker build -t spring-app:latest -f Dockerfile.spring .

# Verify
docker images | grep spring-app
```

See [DOCKER-IMAGES.md](DOCKER-IMAGES.md) for detailed instructions.

## Step 3: Start Kubernetes

```bash
# Run setup script (from project root)
bash kubernetes/setup.sh
```

The script will automatically:
- Start minikube cluster
- Enable ingress
- Create namespace
- Deploy PostgreSQL and Spring app
- Display access information

## Step 4: Access Your Application

After setup, you get the minikube IP. Access via:

```bash
# Get IP
minikube ip

# API endpoint
curl http://<minikube-ip>:8080

# Or use port forwarding
kubectl port-forward -n app-namespace svc/spring-app-service 8080:8080
# Then: curl http://localhost:8080
```

## Step 5: Verify Setup

Check everything is running:

```bash
# View pods
kubectl get pods -n app-namespace

# View deployments
kubectl get deployments -n app-namespace

# View services
kubectl get svc -n app-namespace
```

All should show **Running** status.

## Common Tasks

### View Logs

```bash
# Real-time logs
kubectl logs -n app-namespace -l app=spring-app -f

# Database logs
kubectl logs -n app-namespace deployment/postgres
```

### Access Database

```bash
# Port forward PostgreSQL
kubectl port-forward -n app-namespace svc/postgres-service 5432:5432

# In another terminal
psql -h localhost -U appuser -d appdb
# Password: postgres123
```

### Scale Application

```bash
# Scale to 3 replicas
kubectl scale deployment/spring-app --replicas=3 -n app-namespace

# Check status
kubectl get pods -n app-namespace
```

### Restart Application

```bash
kubectl rollout restart deployment/spring-app -n app-namespace
```

### Deploy New Version

```bash
# Rebuild image
docker build -t spring-app:v2 -f Dockerfile.spring .

# Load into minikube
minikube image load spring-app:v2

# Update deployment
kubectl set image deployment/spring-app \
  spring-app=spring-app:v2 \
  -n app-namespace

# Check rollout
kubectl rollout status deployment/spring-app -n app-namespace
```

## Monitoring

### Dashboard

```bash
minikube dashboard
```

Opens web UI with cluster overview, pods, logs, and resource usage.

### Resource Usage

```bash
# Node resources
kubectl top nodes

# Pod resources
kubectl top pod -n app-namespace
```

## Troubleshooting

### Pods won't start

```bash
# Describe pod
kubectl describe pod <pod-name> -n app-namespace

# View logs
kubectl logs <pod-name> -n app-namespace
```

### Can't access application

```bash
# Check minikube is running
minikube status

# Check services
kubectl get svc -n app-namespace

# Get IP
minikube ip
```

### Image not found

```bash
# Load image
minikube image load spring-app:latest

# Restart deployment
kubectl rollout restart deployment/spring-app -n app-namespace
```

## Stop/Delete Cluster

```bash
# Stop (preserves data)
minikube stop

# Delete everything
minikube delete
```

## Using with Ansible

```bash
# Run Kubernetes playbook
ansible-playbook playbooks/k8s-minikube-setup.yaml
```

Requires: `pip install ansible kubernetes`

## References

- [QUICK-REFERENCE.md](QUICK-REFERENCE.md) - Command reference
- [DOCKER-IMAGES.md](DOCKER-IMAGES.md) - Docker image building
- [Kubernetes Docs](https://kubernetes.io/docs/)
- [minikube Docs](https://minikube.sigs.k8s.io/)

---

**Ready?** Run: `bash kubernetes/setup.sh`
