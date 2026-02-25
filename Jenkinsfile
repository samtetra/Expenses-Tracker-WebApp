pipeline {
    agent any

    environment {
        PROJECT = "expenses-app"
    }

    stages {

        stage('Clone Repo') {
            steps {
                git url: 'https://github.com/samtetra/Expenses-Tracker-WebApp.git'
            }
        }

        stage('SonarQube Scan') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh """
                    sonar-scanner \
                    -Dsonar.projectKey=${PROJECT} \
                    -Dsonar.sources=.
                    """
                }
            }
        }

        stage('Trivy FS Scan') {
            steps {
                sh """
                trivy fs --exit-code 0 --severity HIGH,CRITICAL .
                """
            }
        }

        stage('Build Images') {
            steps {
                sh """
                docker compose build
                """
            }
        }

        stage('Trivy Image Scan') {
            steps {
                sh """
                docker images --format "{{.Repository}}" | grep expenses | \
                xargs -I{} trivy image --exit-code 0 --severity HIGH,CRITICAL {}
                """
            }
        }

        stage('Deploy') {
            steps {
                sh """
                docker compose down || true
                docker compose up -d
                """
            }
        }
    }
}
