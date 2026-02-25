pipeline {
    agent any

    environment {
        PROJECT = "Expenses-Tracker-WebApp"
        SCANNER_HOME = tool 'sonar-scanner'
    }

    stages {

        stage('SonarQube Scan') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh """
                    ${SCANNER_HOME}/bin/sonar-scanner \
                    -Dsonar.projectKey=${PROJECT} \
                    -Dsonar.sources=. \
                    -Dsonar.exclusions=**/*.java
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
