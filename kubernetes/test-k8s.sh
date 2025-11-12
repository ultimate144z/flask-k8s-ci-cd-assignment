#!/bin/bash
# Kubernetes testing script
# Run this script to test the Kubernetes configuration locally

set -e

echo "=== Testing Kubernetes Configuration ==="
echo ""

echo "1. Applying Kubernetes manifests..."
kubectl apply -f kubernetes/

echo ""
echo "2. Verifying deployment status..."
kubectl get pods,services,deployments

echo ""
echo "3. Checking pod details..."
kubectl get pods -l app=flask-app -o wide

echo ""
echo "4. Testing scaling - scaling to 5 replicas..."
kubectl scale deployment flask-app-deploy --replicas=5

echo ""
echo "5. Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=flask-app --timeout=60s

echo ""
echo "6. Verifying scaled deployment..."
kubectl get pods -l app=flask-app

echo ""
echo "7. Testing rollback..."
kubectl rollout undo deployment/flask-app-deploy

echo ""
echo "8. Checking rollout status..."
kubectl rollout status deployment/flask-app-deploy

echo ""
echo "9. Final status check..."
kubectl get pods,services,deployments

echo ""
echo "=== Testing Complete ==="

