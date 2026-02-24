# 📦 Kubernetes Setup - Linux Summary

Simple Kubernetes setup with **minikube** and **kubectl** for Linux.

## What Gets Deployed

✅ **PostgreSQL 16** - Database with persistent storage  
✅ **Spring Boot App** - 2 replicas, auto-healing  
✅ **Ingress Controller** - Direct routing to Spring app  

## Quick Start

```bash
bash kubernetes/setup.sh
```

The script will:
- Install minikube and kubectl
- Start the cluster
- Deploy PostgreSQL and Spring app
- Display access URLs

## Documentation Files

| File | Purpose |
|------|---------|
| **GETTING-STARTED.md** | Complete setup guide |
| **QUICK-REFERENCE.md** | Command reference |
| **DOCKER-IMAGES.md** | Build Docker images |
| **VERIFICATION-CHECKLIST.md** | Validate setup |
| **README.md** | Configuration details |

## Essential Commands

```bash
# View status
kubectl get pods -n app-namespace

# View logs
kubectl logs -n app-namespace -l app=spring-app -f

# Port forward
kubectl port-forward -n app-namespace svc/spring-app-service 8080:8080

# Scale app
kubectl scale deployment/spring-app --replicas=3 -n app-namespace

# Open dashboard
minikube dashboard
```

## Accessing Services

After setup:

```bash
# Get IP
minikube ip

# Spring API
curl http://<ip>:8080

# PostgreSQL
psql -h <ip> -U appuser -d appdb
```

## Prerequisites

- **Linux** (Ubuntu, Debian, CentOS, etc.)
- **RAM**: 8GB minimum
- **Disk**: 20GB+ free space
- **Docker** installed

## File Structure

```
kubernetes/
├── setup.sh                  # Main setup script
├── manage.sh                 # Interactive management menu
├── manifests/                # Kubernetes YAML files
│   ├── namespace.yaml
│   ├── postgres-deployment.yaml
│   ├── spring-deployment.yaml
│   └── ingress.yaml
├── GETTING-STARTED.md        # Full setup guide
├── QUICK-REFERENCE.md        # Commands
├── DOCKER-IMAGES.md          # Build images
├── README.md                 # Configuration
└── VERIFICATION-CHECKLIST.md # Validate
```

## Environment Variables

### PostgreSQL
- User: `appuser`
- Password: `postgres123`
- Database: `appdb`

### Spring Application
- Auto-connected to PostgreSQL
- Health endpoint: `/actuator/health`

## Troubleshooting

```bash
# Check pod status
kubectl describe pod <pod-name> -n app-namespace

# View logs
kubectl logs <pod-name> -n app-namespace

# Execute command in pod
kubectl exec -it <pod-name> -n app-namespace -- /bin/sh
```

---

**Ready?** → Run: `bash kubernetes/setup.sh`
