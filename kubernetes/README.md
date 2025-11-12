# Kubernetes Configuration

This directory contains Kubernetes manifests for deploying the Flask application.

## Files

- `deployment.yaml` - Deployment configuration with rolling updates and resource limits
- `service.yaml` - NodePort service for load balancing
- `test-k8s.sh` - Testing script for Kubernetes operations

## Features

### Deployment
- **Replicas**: 3 pods for high availability
- **Rolling Update Strategy**:
  - `maxSurge: 1` - Maximum number of pods that can be created above desired count
  - `maxUnavailable: 1` - Maximum number of pods that can be unavailable during update
- **Resource Limits**:
  - Requests: 128Mi memory, 100m CPU
  - Limits: 256Mi memory, 500m CPU
- **Health Probes**: Readiness and liveness probes configured

### Service
- **Type**: NodePort (for load balancing)
- **Port**: 80 (targets container port 5000)

## Testing Locally

### Prerequisites
- Kubernetes cluster running (minikube, kind, or cloud cluster)
- kubectl configured and connected to cluster

### Manual Testing Steps

1. **Apply manifests:**
   ```bash
   kubectl apply -f kubernetes/
   ```

2. **Verify deployment status:**
   ```bash
   kubectl get pods,services,deployments
   ```

3. **Check pod details:**
   ```bash
   kubectl get pods -l app=flask-app -o wide
   ```

4. **Test scaling:**
   ```bash
   kubectl scale deployment flask-app-deploy --replicas=5
   kubectl get pods -l app=flask-app
   ```

5. **Test rollback:**
   ```bash
   kubectl rollout undo deployment/flask-app-deploy
   kubectl rollout status deployment/flask-app-deploy
   ```

### Automated Testing

Run the test script:
```bash
./kubernetes/test-k8s.sh
```

## Notes

- Replace `YOUR_GH_USERNAME` in `deployment.yaml` with your GitHub username
- Ensure the Docker image is available in the container registry before deploying

