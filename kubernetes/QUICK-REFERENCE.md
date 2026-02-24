# Quick Reference Guide

Essential kubectl commands for Kubernetes management.

## Cluster Management

```bash
# Start cluster
minikube start --memory=4096 --cpus=2 --driver=docker

# Stop cluster
minikube stop

# Delete cluster
minikube delete

# Get status
minikube status

# Get IP
minikube ip

# Open dashboard
minikube dashboard
```

## View Resources

```bash
# Deployments
kubectl get deployments -n app-namespace
kubectl get deployments -n app-namespace -o wide

# Pods
kubectl get pods -n app-namespace
kubectl get pods -n app-namespace -o wide
kubectl get pods -n app-namespace -w  # Watch

# Services
kubectl get svc -n app-namespace

# All resources
kubectl get all -n app-namespace
```

## Inspect Resources

```bash
# Deployment details
kubectl describe deployment/spring-app -n app-namespace

# Pod details
kubectl describe pod <pod-name> -n app-namespace

# View events
kubectl get events -n app-namespace --sort-by='.lastTimestamp'
```

## Logs

```bash
# View logs
kubectl logs <pod-name> -n app-namespace

# Follow logs (tail)
kubectl logs <pod-name> -n app-namespace -f

# Last 50 lines
kubectl logs <pod-name> -n app-namespace --tail=50

# All pods with app=spring-app label
kubectl logs -n app-namespace -l app=spring-app -f
```

## Deployment Management

```bash
# Apply configuration
kubectl apply -f kubernetes/manifests/

# Delete resources
kubectl delete -f kubernetes/manifests/

# Restart deployment
kubectl rollout restart deployment/spring-app -n app-namespace

# Check rollout status
kubectl rollout status deployment/spring-app -n app-namespace

# Rollback
kubectl rollout undo deployment/spring-app -n app-namespace
```

## Scaling

```bash
# Scale to 3 replicas
kubectl scale deployment/spring-app --replicas=3 -n app-namespace

# Auto-scale (requires metrics-server)
kubectl autoscale deployment/spring-app --min=2 --max=5 -n app-namespace
```

## Port Forwarding

```bash
# Spring App (8080)
kubectl port-forward -n app-namespace svc/spring-app-service 8080:8080

# PostgreSQL (5432)
kubectl port-forward -n app-namespace svc/postgres-service 5432:5432
```

## Debugging

```bash
# Execute command in pod
kubectl exec -it <pod-name> -n app-namespace -- /bin/sh

# Copy file to pod
kubectl cp <file> <pod-name>:/path/to/file -n app-namespace

# Copy file from pod
kubectl cp <pod-name>:/path/to/file <local-file> -n app-namespace

# Run temporary debug pod
kubectl run -it --rm debug --image=alpine -- /bin/sh
```

## Resource Monitoring

```bash
# Node resources
kubectl top nodes

# Pod resources
kubectl top pod -n app-namespace

# Sort by memory
kubectl top pod -n app-namespace --sort-by=memory
```

## Configuration Updates

```bash
# Update image
kubectl set image deployment/spring-app spring-app=spring-app:v2 -n app-namespace

# Edit deployment
kubectl edit deployment/spring-app -n app-namespace

# Set environment variable
kubectl set env deployment/spring-app MYVAR=value -n app-namespace

# Update resource limits
kubectl set resources deployment/spring-app --limits=cpu=500m,memory=512Mi -n app-namespace
```

## Namespace Management

```bash
# Create namespace
kubectl create namespace app-namespace

# Delete namespace
kubectl delete namespace app-namespace

# View all namespaces
kubectl get namespaces
```

## Troubleshooting

```bash
# Cluster status
kubectl cluster-info

# Describe node
kubectl describe node

# Check persistent volumes
kubectl get pv
kubectl get pvc -n app-namespace

# Test DNS resolution
kubectl run -it --rm debug --image=alpine -- nslookup postgres-service.app-namespace.svc.cluster.local
```

## Common Use Cases

**Access Spring API:**
```bash
kubectl port-forward -n app-namespace svc/spring-app-service 8080:8080
curl http://localhost:8080
```

**Access PostgreSQL:**
```bash
kubectl port-forward -n app-namespace svc/postgres-service 5432:5432
psql -h localhost -U appuser -d appdb
```

**View Spring logs in real-time:**
```bash
kubectl logs -n app-namespace -l app=spring-app -f
```

**Scale Spring app:**
```bash
kubectl scale deployment/spring-app --replicas=5 -n app-namespace
```

**Restart a pod:**
```bash
kubectl rollout restart deployment/spring-app -n app-namespace
```

## Useful Aliases

Add to ~/.bashrc or ~/.zshrc:

```bash
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
alias kl='kubectl logs'
alias ke='kubectl exec -it'
alias kaf='kubectl apply -f'
alias kdf='kubectl delete -f'
```

Then use: `k get pods -n app-namespace`, `kl -n app-namespace -f`, etc.
