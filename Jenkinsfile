pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }
    stage('Install Deps') {
      steps {
        sh 'python3 -m venv venv || true'
        sh '. venv/bin/activate && pip install -r requirements.txt'
      }
    }
    stage('Unit Tests') {
      steps {
        // Placeholder: add tests later; keep stage for structure
        sh 'echo "No tests yet. Add pytest later."'
      }
    }
    stage('Build Docker') {
      steps {
        sh 'docker build -t flask-k8s-ci-cd-assignment:local .'
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: '**/*', fingerprint: true, onlyIfSuccessful: false
    }
  }
}

