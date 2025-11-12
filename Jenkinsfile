pipeline {
  agent any

  environment {
    DOCKER_IMAGE = 'flask-k8s-ci-cd-assignment'
    DOCKER_TAG = "${env.BUILD_NUMBER}"
    KUBECTL_NAMESPACE = 'default'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          echo "Building Docker image: ${DOCKER_IMAGE}:${DOCKER_TAG}"
          bat """
            docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
            docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest
          """
        }
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        script {
          echo "Deploying to Kubernetes namespace: ${KUBECTL_NAMESPACE}"
          bat """
            kubectl apply -f kubernetes/ --namespace=${KUBECTL_NAMESPACE}
          """
        }
      }
    }

    stage('Verify Deployment') {
      steps {
        script {
          echo "Verifying deployment status..."
          bat """
            echo Checking rollout status...
            kubectl rollout status deployment/flask-app-deploy --namespace=${KUBECTL_NAMESPACE} --timeout=120s
            
            echo Verifying pods...
            kubectl get pods -l app=flask-app --namespace=${KUBECTL_NAMESPACE}
            
            echo Verifying services...
            kubectl get services -l app=flask-app --namespace=${KUBECTL_NAMESPACE}
            
            echo Checking pod status...
            kubectl get pods -l app=flask-app --namespace=${KUBECTL_NAMESPACE} -o jsonpath="{.items[*].status.phase}" | findstr Running >nul || exit /b 1
          """
        }
      }
    }
  }

  post {
    success {
      echo "Pipeline completed successfully!"
      bat """
        echo Final deployment status:
        kubectl get pods,services,deployments -l app=flask-app --namespace=${KUBECTL_NAMESPACE}
      """
    }
    failure {
      echo "Pipeline failed!"
      bat """
        echo Current pod status:
        kubectl get pods -l app=flask-app --namespace=${KUBECTL_NAMESPACE}
        echo Pod logs (last 50 lines):
        kubectl logs -l app=flask-app --namespace=${KUBECTL_NAMESPACE} --tail=50 || echo Log fetch failed
      """
    }
    always {
      archiveArtifacts artifacts: '**/*', fingerprint: true, onlyIfSuccessful: false
    }
  }
}
