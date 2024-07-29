pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                script {
                    docker.build('my-web-app')
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    docker.image('my-web-app').inside {
                        sh 'npm test'
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-credentials') {
                        docker.image('my-web-app').push()
                    }
                }
            }
        }
    }
}
