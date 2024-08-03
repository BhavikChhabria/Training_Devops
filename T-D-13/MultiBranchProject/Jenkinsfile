pipeline {
    agent any

    environment {
        GREETING = 'Hello, World!'
    }

    stages {
        stage('Build') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'development') {
                        echo "Building Development Branch"
                    } else if (env.BRANCH_NAME == 'staging') {
                        echo "Building Staging Branch"
                    } else if (env.BRANCH_NAME == 'production') {
                        echo "Building Production Branch"
                    }
                }
                sh 'mvn clean package'
            }
        }
        stage('Deploy') {
            steps {
                script {
                    echo "Deploying to environment"
                    echo "${GREETING}"
                }
            }
        }
    }

    post {
        always {
            echo 'This will always run'
        }
        success {
            echo 'This will run only if successful'
        }
        failure {
            echo 'This will run only if failed'
        }
    }
}

