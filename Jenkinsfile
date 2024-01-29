pipeline {

    agent any

    stages {

        stage('checkout') {
            // Cloning the source code from GitHub.
            steps {
                git branch: 'dev-branch', url: 'https://github.com/stephanemiafo/terraformforiam.git'
                echo 'Clonning the source code.'
            }
        }
        stage('Initialization_and_formating') {
            // Initialize the environment.
            steps {
                withCredentials([aws(credentialsId: 'aws-integration-credentials', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh '''
                        terraform init
                        terraform fmt
                    '''
                } 
            } 
        }
    }
}


