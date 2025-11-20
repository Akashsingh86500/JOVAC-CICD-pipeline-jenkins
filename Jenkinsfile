pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Deploy Service A') {
            steps {
                build job: 'service-a-pipeline'
            }
        }

        stage('Deploy Service B') {
            steps {
                build job: 'service-b-pipeline'
            }
        }
    }
}
