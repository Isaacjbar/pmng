pipeline {
    agent any

    environment {
        COMPOSE_PROJECT_NAME = 'pmng'
        // Jenkins "Secret file" credential with id: pmng-env
        PMNG_ENV_FILE = credentials('pmng-env')
    }

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    stages {
        stage('Parar servicios') {
            steps {
                sh '''
                    cp "$PMNG_ENV_FILE" .env
                    docker compose down --remove-orphans
                '''
            }
        }

        stage('Eliminar imagenes antiguas') {
            steps {
                sh '''
                    docker rmi -f pmng-back:latest pmng-front:latest || true
                    docker image prune -f
                '''
            }
        }

        stage('Construir imagenes') {
            steps {
                sh 'docker compose build --no-cache'
            }
        }

        stage('Desplegar servicios') {
            steps {
                sh '''
                    docker compose up -d
                    docker compose ps
                '''
            }
        }
    }

    post {
        always {
            sh 'rm -f .env'
        }
        success {
            echo 'Deploy OK: front :5173, back :8089'
        }
        failure {
            sh 'docker compose logs --tail=50 || true'
        }
    }
}
