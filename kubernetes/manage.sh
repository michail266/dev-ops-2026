#!/bin/bash
# Kubernetes Cluster Management Script

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_header() {
    echo -e "\n${YELLOW}========== $1 ==========${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

show_menu() {
    echo -e "${YELLOW}Kubernetes Management${NC}"
    echo "1. View cluster status"
    echo "2. View deployments"
    echo "3. View pods"
    echo "4. View services"
    echo "5. View logs"
    echo "6. Port forward"
    echo "7. Scale deployment"
    echo "8. Open dashboard"
    echo "9. Restart deployment"
    echo "10. Get minikube IP"
    echo "11. Exit"
    echo ""
}

view_status() {
    print_header "Cluster Status"
    kubectl cluster-info
    echo ""
    kubectl get nodes
}

view_deployments() {
    print_header "Deployments"
    kubectl get deployments -n app-namespace -o wide
}

view_pods() {
    print_header "Pods"
    kubectl get pods -n app-namespace -o wide
}

view_services() {
    print_header "Services"
    kubectl get svc -n app-namespace -o wide
}

view_logs() {
    print_header "View Logs"
    echo "Available pods:"
    kubectl get pods -n app-namespace -o name
    echo ""
    read -p "Enter pod name: " pod_name
    read -p "Number of lines (default 50): " lines
    lines=${lines:-50}
    
    echo -e "\n${YELLOW}Fetching last $lines lines of logs...${NC}\n"
    kubectl logs -n app-namespace "$pod_name" --tail="$lines" -f
}

port_forward() {
    print_header "Port Forward"
    echo "Services available:"
    echo "1. spring-app-service (8080)"
    echo "2. postgres-service (5432)"
    read -p "Choose service (1-2): " choice
    
    case $choice in
        1)
            print_info "Forwarding Spring App on http://localhost:8080"
            kubectl port-forward -n app-namespace svc/spring-app-service 8080:8080
            ;;
        2)
            print_info "Forwarding PostgreSQL on localhost:5432"
            kubectl port-forward -n app-namespace svc/postgres-service 5432:5432
            ;;
        *)
            print_info "Invalid choice"
            ;;
    esac
}

scale_deployment() {
    print_header "Scale Deployment"
    echo "Available deployments:"
    kubectl get deployments -n app-namespace -o name | cut -d/ -f2
    echo ""
    read -p "Deployment name: " deployment
    read -p "Number of replicas: " replicas
    
    kubectl scale deployment/"$deployment" --replicas="$replicas" -n app-namespace
    print_success "Scaled $deployment to $replicas replicas"
}

open_dashboard() {
    print_header "Opening Kubernetes Dashboard"
    minikube dashboard
}

restart_deployment() {
    print_header "Restart Deployment"
    echo "Available deployments:"
    kubectl get deployments -n app-namespace -o name | cut -d/ -f2
    echo ""
    read -p "Deployment name: " deployment
    
    kubectl rollout restart deployment/"$deployment" -n app-namespace
    print_success "Restarted $deployment"
}

get_minikube_ip() {
    print_header "Cluster IP Information"
    MINIKUBE_IP=$(minikube ip)
    echo -e "Minikube IP: ${GREEN}${MINIKUBE_IP}${NC}"
    echo ""
    echo "Access your services:"
    echo -e "  Spring API: ${GREEN}http://${MINIKUBE_IP}:8080${NC}"
    echo -e "  PostgreSQL: ${GREEN}${MINIKUBE_IP}:5432${NC}"
}

# Main loop
while true; do
    show_menu
    read -p "Select option: " option
    
    case $option in
        1) view_status ;;
        2) view_deployments ;;
        3) view_pods ;;
        4) view_services ;;
        5) view_logs ;;
        6) port_forward ;;
        7) scale_deployment ;;
        8) open_dashboard ;;
        9) restart_deployment ;;
        10) get_minikube_ip ;;
        11) echo "Exiting..."; exit 0 ;;
        *) print_info "Invalid option" ;;
    esac
done
