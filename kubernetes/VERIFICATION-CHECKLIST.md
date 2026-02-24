# Kubernetes Setup Verification Checklist

Verify your Kubernetes setup is working correctly.

## Prerequisites ✓

- [ ] Docker installed and running
  ```bash
  docker --version
  docker ps
  ```

- [ ] minikube installed
  ```bash
  minikube version
  ```

- [ ] kubectl installed
  ```bash
  kubectl version --client
  ```

- [ ] 8GB+ RAM, 20GB+ disk space

## Initial Setup ✓

- [ ] Ran `bash kubernetes/setup.sh` successfully
- [ ] No errors during script execution
- [ ] Script completed with "Access your application" message

## Cluster Status ✓

```bash
# Check cluster is running
kubectl cluster-info
```

- [ ] Cluster responds to commands
- [ ] Kubernetes master is accessible

```bash
# Check minikube status
minikube status
```

- [ ] minikube shows 'Running'
- [ ] kubelet shows 'Running'

## Docker Images ✓

```bash
# List images in minikube
minikube image ls
```

- [ ] `spring-app:latest` is present

## Namespace & Resources ✓

```bash
# Check namespace exists
kubectl get namespace app-namespace
```

- [ ] `app-namespace` is listed

```bash
# Check deployments
kubectl get deployments -n app-namespace
```

- [ ] `postgres` deployment listed
- [ ] `spring-app` deployment listed

```bash
# Check all deployments are ready
kubectl get deployments -n app-namespace -o wide
```

- [ ] All DESIRED and READY counts match
- [ ] All deployments show 'Available'

## Pods ✓

```bash
# Check all pods are running
kubectl get pods -n app-namespace
```

- [ ] All pods show 'Running' status
- [ ] No pods in 'Pending', 'CrashLoopBackOff', or 'Error' state

```bash
# Check pod details
kubectl get pods -n app-namespace -o wide
```

- [ ] PostgreSQL pod is running
- [ ] Spring app pods are running (2 replicas)

## Services ✓

```bash
# Check services exist
kubectl get svc -n app-namespace
```

- [ ] `spring-app-service` is listed
- [ ] `postgres-service` is listed

```bash
# Check service endpoints
kubectl get endpoints -n app-namespace
```

- [ ] All services have endpoints assigned

## Network Connectivity ✓

```bash
# Get minikube IP
minikube ip
```

- [ ] IP address is returned

```bash
# Test Spring app connectivity
kubectl run -it --rm debug --image=alpine -- wget -qO- http://spring-app-service:8080/health
```

- [ ] Service responds to internal requests

```bash
# Test database connectivity
kubectl run -it --rm debug --image=alpine -- ping -c 1 postgres-service
```

- [ ] Database service responds

## Volume & Storage ✓

```bash
# Check persistent volume claims
kubectl get pvc -n app-namespace
```

- [ ] PVC for PostgreSQL is listed
- [ ] Status shows 'Bound'

## Resource Monitoring ✓

```bash
# Check pod resources
kubectl top pod -n app-namespace
```

- [ ] All pods show resource usage
- [ ] No pod shows extremely high usage

## Logs ✓

```bash
# Check PostgreSQL logs
kubectl logs -n app-namespace deployment/postgres --tail=20
```

- [ ] Database shows initialization messages
- [ ] Ready to accept connections

```bash
# Check Spring app logs
kubectl logs -n app-namespace -l app=spring-app --tail=20
```

- [ ] Application shows startup messages
- [ ] No critical errors

## Port Forwarding ✓

### Terminal 1:
```bash
kubectl port-forward -n app-namespace svc/spring-app-service 8080:8080
```
- [ ] Command shows "Forwarding from 127.0.0.1:8080 -> 8080"

### Terminal 2:
```bash
curl http://localhost:8080/health
```
- [ ] Request succeeds
- [ ] Response indicates service is UP

### Terminal 3:
```bash
kubectl port-forward -n app-namespace svc/postgres-service 5432:5432
```
- [ ] PostgreSQL forwards successfully

### Verify with psql:
```bash
psql -h localhost -U appuser -d appdb
```
- [ ] Connection succeeds

## Dashboard ✓

```bash
minikube dashboard
```

- [ ] Browser opens with dashboard
- [ ] 2 deployments shown
- [ ] All components show Ready status

## Advanced Verification ✓

### Check environment variables:
```bash
kubectl exec -it <spring-app-pod> -n app-namespace -- env | grep SPRING
```
- [ ] Database connection variables are set

### Check health endpoint:
```bash
kubectl exec -it <spring-app-pod> -n app-namespace -- curl localhost:8080/actuator/health
```
- [ ] Health endpoint responds

## Clean Shutdown ✓

### Test stopping cluster:
```bash
minikube stop
minikube status
```
- [ ] minikube shows 'Stopped'

### Test restarting cluster:
```bash
minikube start
kubectl get pods -n app-namespace
```
- [ ] Cluster restarts successfully
- [ ] Pods come back up
- [ ] Data persists

## Troubleshooting Guide

### If pods won't start:
```bash
kubectl describe pod <pod-name> -n app-namespace
kubectl logs <pod-name> -n app-namespace
```

### If services can't communicate:
```bash
kubectl run -it --rm debug --image=alpine -- nslookup spring-app-service.app-namespace
kubectl run -it --rm debug --image=alpine -- wget -qO- http://spring-app-service:8080
```

### If minikube is unhealthy:
```bash
minikube delete
minikube start --memory=4096 --cpus=2 --driver=docker
```

### If image is missing:
```bash
minikube image load spring-app:latest
kubectl rollout restart deployment/spring-app -n app-namespace
```

## Success Criteria

✅ **All of the following:**
- [ ] All pods are in 'Running' status
- [ ] All deployments show READY 2/2
- [ ] All services have endpoints
- [ ] Database responds on port 5432
- [ ] Spring app responds on port 8080
- [ ] No critical error logs
- [ ] Resource usage is normal

---

**Verification Complete!** Your Kubernetes cluster is ready. 🎉
