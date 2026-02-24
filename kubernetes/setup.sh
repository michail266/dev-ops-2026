#!/bin/bash
# Kubernetes Minikube Setup - Linux

set -e

echo "=========================================="
echo "Kubernetes Setup with Minikube"
echo "=========================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_info() {
    echo -e "${YELLOW}[i]${NC} $1"
}

# Check Docker
if ! command -v docker &> /dev/null; then
    print_error "Docker not installed. Install Docker first: https://docs.docker.com/engine/install/"
    exit 1
fi
print_status "Docker is installed"

# Install minikube if needed
if ! command -v minikube &> /dev/null; then
    print_info "Installing minikube..."
    curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    rm minikube-linux-amd64
    print_status "Minikube installed"
else
    print_status "Minikube is installed"
fi

# Install kubectl if needed
if ! command -v kubectl &> /dev/null; then
    print_info "Installing kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl
    print_status "kubectl installed"
else
    print_status "kubectl is installed"
fi

echo ""
print_info "Starting minikube cluster..."
minikube start --memory=4096 --cpus=2 --driver=docker

echo ""
print_info "Enabling ingress addon..."
minikube addons enable ingress

echo ""
print_info "Creating namespace and deploying applications..."
kubectl create namespace app-namespace --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f kubernetes/manifests/postgres-deployment.yaml
kubectl apply -f kubernetes/manifests/spring-deployment.yaml
kubectl apply -f kubernetes/manifests/ingress.yaml

echo ""
print_info "Waiting for deployments to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/postgres -n app-namespace || true
kubectl wait --for=condition=available --timeout=300s deployment/spring-app -n app-namespace || true

echo ""
MINIKUBE_IP=$(minikube ip)
print_status "Setup complete!"
echo ""
echo "=========================================="
echo "Access your application:"
echo "=========================================="
echo "Spring API: http://$MINIKUBE_IP:8080"
echo "PostgreSQL: $MINIKUBE_IP:5432"
echo ""
echo "Useful commands:"
echo "  kubectl get pods -n app-namespace"
echo "  kubectl logs -n app-namespace -l app=spring-app -f"
echo "  kubectl port-forward -n app-namespace svc/spring-app-service 8080:8080"
echo "  minikube dashboard"
echo "=========================================="
