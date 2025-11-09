pipeline {
  agent any
  environment {
    EC2_HOST = '54.252.194.194'
    SSH_CREDENTIALS_ID = 'EC2_PEM_KEY'
    REPO_URL = 'https://github.com/Akashsingh86500/JOVAC-CICD-pipeline-jenkins.git'
  }
  stages {
    stage('checkout') {
      steps { checkout scm }
    }
    stage('build service-a') {
      steps { dir('service-a') { sh 'npm ci' } }
    }
    stage('build service-b') {
      steps { dir('service-b') { sh 'python -m venv .venv || true'; sh '. .venv/bin/activate; pip install -r requirements.txt' } }
    }
    stage('deploy') {
      steps {
        sshagent (credentials: [env.SSH_CREDENTIALS_ID]) {
          sh "ssh -o StrictHostKeyChecking=no ec2-user@${EC2_HOST} 'bash -s' < scripts/deploy_app.sh service-a"
          sh "ssh -o StrictHostKeyChecking=no ec2-user@${EC2_HOST} 'bash -s' < scripts/deploy_app.sh service-b"
        }
      }
    }
  }
}
