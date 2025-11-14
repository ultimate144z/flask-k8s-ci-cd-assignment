Flask Kubernetes CI/CD Assignment

This project demonstrates a complete CI/CD pipeline for a Flask application deployed on Kubernetes. It includes GitHub Actions for continuous integration, Jenkins for continuous delivery, and Kubernetes for container orchestration with automated rollouts, scaling, and load balancing.

Project Overview

This Flask application serves as a demonstration of modern DevOps practices, integrating multiple tools and platforms to create an automated deployment pipeline. The application is containerized using Docker, tested through GitHub Actions, and deployed to Kubernetes via Jenkins.

Kubernetes Features

The Kubernetes deployment configuration includes several production-ready features:

Rolling Updates: The deployment uses a rolling update strategy with maxSurge: 1 and maxUnavailable: 1. This ensures that during updates, at least one pod remains available while new versions are gradually rolled out, minimizing downtime.

Scaling: The deployment is configured with 3 replicas by default, providing high availability. You can scale the application horizontally using kubectl scale commands, and Kubernetes will automatically manage the pod distribution.

Load Balancing: A NodePort service is configured to distribute incoming traffic across all available pods. The service listens on port 80 and forwards requests to the container port 5000, ensuring even distribution of load.

Resource Management: CPU and memory limits are defined to prevent resource exhaustion. The deployment requests 128Mi memory and 100m CPU, with limits set to 256Mi memory and 500m CPU.

Health Probes: Both readiness and liveness probes are configured to ensure pods are healthy before receiving traffic and to automatically restart unhealthy containers.

Building and Running Locally with Docker

Prerequisites

- Docker installed on your system
- Git (to clone the repository)

Steps

1. Clone the repository:
   git clone https://github.com/ultimate144z/flask-k8s-ci-cd-assignment.git
   cd flask-k8s-ci-cd-assignment

2. Build the Docker image:
   docker build -t flask-k8s-ci-cd-assignment:latest .

   This command builds a multi-stage Docker image. The build stage installs dependencies, and the runtime stage creates a minimal production image.

3. Run the container:
   docker run -p 5000:5000 flask-k8s-ci-cd-assignment:latest

4. Test the application:
   Open your browser or use curl to access the application:
   curl http://localhost:5000

   You should receive a JSON response with a welcome message.

5. Stop the container:
   Press Ctrl+C in the terminal where the container is running, or use:
   docker ps
   docker stop <container-id>

Deploying to Kubernetes Using Jenkins Pipeline

Prerequisites

- Jenkins installed and running
- Minikube or a Kubernetes cluster accessible from Jenkins
- kubectl configured and accessible from Jenkins
- Jenkins has access to the GitHub repository

Jenkins Pipeline Setup

1. Create a Pipeline Job in Jenkins:
   - Go to Jenkins dashboard and click "New Item"
   - Enter a job name and select "Pipeline"
   - In the Pipeline configuration, select "Pipeline script from SCM"
   - Choose Git as the SCM
   - Enter the repository URL: https://github.com/ultimate144z/flask-k8s-ci-cd-assignment.git
   - Set the branch to main
   - Set the script path to Jenkinsfile
   - Save the configuration

2. Configure kubectl Access:
   - Ensure Jenkins has access to your Kubernetes cluster
   - If using minikube, configure Jenkins to use the minikube kubeconfig
   - Test kubectl access from Jenkins by running a test command

3. Update Deployment Image:
   - Before deploying, update the image reference in kubernetes/deployment.yaml
   - Replace YOUR_GH_USERNAME with your GitHub username if using GitHub Container Registry
   - Or update to use a local image if deploying to minikube

4. Run the Pipeline:
   - Click "Build Now" on the Jenkins job
   - The pipeline will execute three stages:
     - Build Docker Image: Creates a Docker image tagged with the build number
     - Deploy to Kubernetes: Applies the Kubernetes manifests using kubectl
     - Verify Deployment: Checks rollout status and verifies pods and services are running

5. Monitor the Deployment:
   - Watch the Jenkins console output for progress
   - The pipeline will show the status of each stage
   - If successful, you'll see confirmation that pods are running

6. Verify Deployment:
   kubectl get pods -l app=flask-app
   kubectl get services -l app=flask-app
   kubectl rollout status deployment/flask-app-deploy

Automated Rollouts

When you push changes to the main branch and trigger the Jenkins pipeline, Kubernetes performs a rolling update automatically. The deployment strategy ensures:

- New pods are created before old ones are terminated
- At least one pod remains available during the update
- If a new pod fails health checks, the rollout is paused
- You can rollback using kubectl rollout undo if needed

Scaling

To scale the application, you can either:

1. Manual Scaling:
   kubectl scale deployment flask-app-deploy --replicas=5

2. Update the deployment.yaml:
   Change the replicas field in kubernetes/deployment.yaml and apply:
   kubectl apply -f kubernetes/deployment.yaml

Kubernetes will automatically create or terminate pods to match the desired replica count.

Load Balancing

The NodePort service automatically distributes traffic across all healthy pods. When you access the service through its NodePort, Kubernetes load balances requests using round-robin by default. You can verify this by checking the service:

kubectl get service flask-app-svc

The service exposes the application on a NodePort (typically in the 30000-32767 range) which you can access from outside the cluster.

Project Structure

flask-k8s-ci-cd-assignment/
├── app.py                    # Flask application
├── utils.py                  # Utility functions
├── requirements.txt          # Python dependencies
├── Dockerfile               # Multi-stage Docker build
├── Jenkinsfile              # Jenkins declarative pipeline
├── .github/
│   └── workflows/
│       └── ci.yml           # GitHub Actions CI workflow
├── kubernetes/
│   ├── deployment.yaml      # Kubernetes deployment manifest
│   ├── service.yaml         # Kubernetes service manifest
│   └── test-k8s.sh          # Kubernetes testing script
└── tests/
    └── test_utils.py         # Unit tests

Testing

The project includes automated testing through GitHub Actions:

- Linting: flake8 checks code style with a maximum line length of 90 characters
- Unit Tests: pytest runs unit tests for utility functions

To run tests locally:

# Install dependencies
pip install -r requirements.txt

# Run linting
flake8 . --max-line-length=90 --exclude=venv,__pycache__,.git

# Run unit tests
pytest tests/ -v

CI/CD Pipeline Flow

1. Developer pushes code to a feature branch
2. GitHub Actions automatically runs:
   - Code checkout
   - Python environment setup
   - Dependency installation
   - Linting (flake8)
   - Unit tests (pytest)
   - Docker image build
3. Pull Request is created and reviewed
4. After merge to main, Jenkins pipeline:
   - Builds Docker image
   - Deploys to Kubernetes
   - Verifies deployment status
5. Kubernetes manages:
   - Rolling updates
   - Pod scaling
   - Load balancing
   - Health monitoring

Troubleshooting

Pods not starting
kubectl describe pod <pod-name>
kubectl logs <pod-name>

Service not accessible
kubectl get service flask-app-svc
kubectl get endpoints flask-app-svc

Jenkins pipeline fails
- Check Jenkins console output for error messages
- Verify kubectl is configured correctly
- Ensure Kubernetes cluster is accessible from Jenkins
- Verify Docker image exists and is accessible

Notes

- Replace YOUR_GH_USERNAME in kubernetes/deployment.yaml with your actual GitHub username if using GitHub Container Registry
- For minikube deployments, you may need to use imagePullPolicy: Never and load the image into minikube using minikube image load
- The default namespace is default. Modify the namespace in the Jenkinsfile if deploying to a different namespace
