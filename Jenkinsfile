pipeline {
  agent {
    docker {
      image 'ubuntu:22.04'
      args '--privileged -u root'
    }
  }

  environment {
    EC2_HOST = '54.252.194.194'
    SSH_CREDENTIALS_ID = 'EC2_PEM_KEY'
    REPO_URL = 'https://github.com/Akashsingh86500/JOVAC-CICD-pipeline-jenkins.git'
  }

  stages {

    stage('Install Dependencies Inside Docker') {
      steps {
        sh '''
          apt-get update
          apt-get install -y curl git ssh python3 python3-venv python3-pip
          apt-get install -y nodejs npm
        '''
      }
    }

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build service-a') {
      steps {
        dir('service-a') {
          sh 'npm ci'
        }
      }
    }

    stage('Build service-b') {
      steps {
        dir('service-b') {
          sh 'python3 -m venv .venv'
          sh '. .venv/bin/activate && pip install -r requirements.txt'
        }
      }
    }

    stage('Deploy to EC2') {
      steps {
        sshagent (credentials: [env.SSH_CREDENTIALS_ID]) {
          sh """
            ssh -o StrictHostKeyChecking=no ec2-user@${EC2_HOST} 'bash -s' < scripts/deploy_app.sh service-a
          """
          sh """
            ssh -o StrictHostKeyChecking=no ec2-user@${EC2_HOST} 'bash -s' < scripts/deploy_app.sh service-b
          """
        }
      }
    }
  }
}
