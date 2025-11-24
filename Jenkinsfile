pipeline {
    agent any

    environment {
        EC2_HOST = '3.27.239.46'
        GITHUB_CREDENTIALS_ID = 'GITHUB_RSA_KEY'
        REPO_URL = 'git@github.com:Akashsingh86500/JOVAC-CICD-pipeline-jenkins.git'
    }

    stages {

        stage('Checkout') {
    steps {
        echo 'Fetching latest source code...'
        checkout([$class: 'GitSCM', branches: [[name: '*/main']], 
                  userRemoteConfigs: [[credentialsId: 'GITHUB_RSA_KEY', url: 'git@github.com:Akashsingh86500/JOVAC-CICD-pipeline-jenkins.git']]])
    }
}

        stage('Deploy Service A') {
            steps {
                build job: 'service-a-pipeline', propagate: true
            }
        }

        stage('Deploy Service B') {
            steps {
                build job: 'service-b-pipeline', propagate: true
            }
        }
    }

    post {
        success {
            echo "🔥 Deployment Completed Successfully!"
        }
        failure {
            echo "❌ Deployment Failed. Check Logs!"
        }
    }
}
