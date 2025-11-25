pipeline {
    agent any

    environment {
        EC2_HOST = '44.221.77.210'
        SSH_CREDENTIALS_ID = 'EC2_PEM_KEY'
        GITHUB_CREDENTIALS_ID = 'GITHUB_HTTPS_CRED'
        REPO_URL = 'https://github.com/Akashsingh86500/JOVAC-CICD-pipeline-jenkins.git'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Fetching latest source code...'
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        credentialsId: env.GITHUB_CREDENTIALS_ID,
                        url: env.REPO_URL
                    ]]
                ])
            }
        }

        stage('Build & Deploy Service A') {
            steps {
                dir('service-a') {
                    echo 'Installing Node modules...'
                    sh 'npm install'
                }

                echo 'Deploying service-a...'
                sshagent(credentials: [env.SSH_CREDENTIALS_ID]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ubuntu@${EC2_HOST} \
                        "REPO_URL=${REPO_URL} bash -s service-a" < scripts/deploy_app.sh
                    """
                }
            }
        }

        stage('Build & Deploy Service B') {
            steps {
                dir('service-b') {
                    echo 'Setting up Python venv & installing requirements...'
                    sh '''
                        python3 -m venv .venv
                        . .venv/bin/activate
                        pip install -r requirements.txt
                    '''
                }

                echo 'Deploying service-b...'
                sshagent(credentials: [env.SSH_CREDENTIALS_ID]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ubuntu@${EC2_HOST} \
                        "REPO_URL=${REPO_URL} bash -s service-b" < scripts/deploy_app.sh
                    """
                }
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
