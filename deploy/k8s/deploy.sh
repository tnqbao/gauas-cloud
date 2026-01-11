#!/bin/bash

# Gauas Cloud Stack - Kubernetes Deployment Script
# This script deploys the entire Gauas Cloud Stack to Kubernetes

set -e

echo "======================================"
echo "Gauas Cloud Stack - K8s Deployment"
echo "======================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}Error: kubectl is not installed${NC}"
    exit 1
fi

# Check if kustomize is installed
if ! command -v kustomize &> /dev/null; then
    echo -e "${YELLOW}Warning: kustomize is not installed. Using kubectl apply -k${NC}"
    KUSTOMIZE_CMD="kubectl apply -k"
else
    KUSTOMIZE_CMD="kustomize build . | kubectl apply -f -"
fi

echo -e "${GREEN}Deploying Gauas Cloud Stack...${NC}"
echo ""

# Change to k8s directory
cd "$(dirname "$0")"

# Apply kustomization
echo -e "${YELLOW}Applying Kubernetes manifests...${NC}"
kubectl apply -k .

echo ""
echo -e "${GREEN}Deployment completed!${NC}"
echo ""
echo "Checking deployment status..."
echo ""

# Wait for deployments
echo -e "${YELLOW}Waiting for deployments to be ready...${NC}"
kubectl wait --for=condition=available --timeout=300s \
    deployment --all -n gauas-cloud-stack || true

echo ""
echo "======================================"
echo "Deployment Status"
echo "======================================"
echo ""

# Show pods status
echo -e "${YELLOW}Pods:${NC}"
kubectl get pods -n gauas-cloud-stack

echo ""
echo -e "${YELLOW}Services:${NC}"
kubectl get svc -n gauas-cloud-stack

echo ""
echo -e "${YELLOW}Ingress:${NC}"
kubectl get ingress -n gauas-cloud-stack

echo ""
echo "======================================"
echo "Access Information"
echo "======================================"
echo ""
echo -e "${GREEN}Frontend:${NC} https://cloud.gauas.online"
echo -e "${GREEN}API Gateway:${NC} https://api.gauas.online"
echo -e "${GREEN}MinIO Console:${NC} https://minio.gauas.online"
echo -e "${GREEN}RabbitMQ Management:${NC} https://rabbitmq.gauas.online"
echo ""
echo -e "${YELLOW}Note: Make sure DNS records are configured for the above domains${NC}"
echo ""
echo "======================================"
echo "Useful Commands"
echo "======================================"
echo ""
echo "View logs:"
echo "  kubectl logs -f deployment/<service-name> -n gauas-cloud-stack"
echo ""
echo "Scale deployment:"
echo "  kubectl scale deployment/<service-name> --replicas=3 -n gauas-cloud-stack"
echo ""
echo "Delete all resources:"
echo "  kubectl delete -k ."
echo ""
echo "======================================"

