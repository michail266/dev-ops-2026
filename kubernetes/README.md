# Kubernetes Configuration Guide

Simple Kubernetes setup for Linux using **minikube** and **kubectl**.

## Quick Start

```bash
# Run setup script
bash kubernetes/setup.sh
```

The script will:
- Install minikube and kubectl (if needed)
- Start the cluster
- Deploy PostgreSQL and Spring application

## What Gets Deployed

- **PostgreSQL 16** - Database with persistent storage
- **Spring Boot App** - 2 replicas, auto-healing
- **Ingress** - Direct routing to Spring application

## Accessing Services

After setup completes, get the minikube IP:
```bash
minikube ip
```

Access your application:
- **Spring API**: `http://<minikube-ip>:8080`
- **PostgreSQL**: `<minikube-ip>:5432` (user: appuser, password: postgres123)

Or use port forwarding:
```bash
kubectl port-forward -n app-namespace svc/spring-app-service 8080:8080
# Then: http://localhost:8080
```

## Common Commands

```bash
# View status
kubectl get pods -n app-namespace
kubectl get deployments -n app-namespace

# View logs
kubectl logs -n app-namespace -l app=spring-app -f

# Scale deployment
kubectl scale deployment/spring-app --replicas=3 -n app-namespace

# Open dashboard
minikube dashboard
```

## Troubleshooting

```bash
# Check pod details
kubectl describe pod <pod-name> -n app-namespace

# View logs
kubectl logs <pod-name> -n app-namespace

# Access pod shell
kubectl exec -it <pod-name> -n app-namespace -- /bin/sh
```

## Stop/Delete Cluster

```bash
# Stop (keeps data)
minikube stop

# Delete everything
minikube delete
```

For more details, see [GETTING-STARTED.md](GETTING-STARTED.md) and [QUICK-REFERENCE.md](QUICK-REFERENCE.md).
