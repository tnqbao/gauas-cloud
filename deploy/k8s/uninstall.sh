#!/bin/bash

# Gauas Cloud Stack - Kubernetes Uninstall Script
# This script removes the entire Gauas Cloud Stack from Kubernetes

set -e

echo "======================================"
echo "Gauas Cloud Stack - K8s Uninstall"
echo "======================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Confirmation prompt
echo -e "${RED}WARNING: This will delete all Gauas Cloud Stack resources!${NC}"
echo -e "${YELLOW}This includes all data in PersistentVolumes!${NC}"
echo ""
read -p "Are you sure you want to continue? (type 'yes' to confirm): " -r
echo ""

if [[ ! $REPLY == "yes" ]]; then
    echo "Uninstall cancelled."
    exit 0
fi

# Change to k8s directory
cd "$(dirname "$0")"

echo -e "${YELLOW}Deleting Gauas Cloud Stack resources...${NC}"
echo ""

# Delete all resources using kustomization
kubectl delete -k . || true

echo ""
echo -e "${YELLOW}Deleting PersistentVolumeClaims...${NC}"
kubectl delete pvc --all -n gauas-cloud-stack || true

echo ""
echo -e "${YELLOW}Deleting namespace...${NC}"
kubectl delete namespace gauas-cloud-stack || true

echo ""
echo -e "${GREEN}Uninstall completed!${NC}"
echo ""

