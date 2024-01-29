pipeline {

    agent any
    /*
    Use of AWS supported environment variables for credentials. The helper method credentials()
    is used to access pre-defined credentials with their identifier in Jenkins environment.
    */
    environment {
        AWS_ACCESS_KEY_ID = credentilas(AWS_ACCESS_KEY_ID)
        AWS_SECRET_ACCESS_KEY = credentilas(AWS_SECRET_ACCESS_KEY)
    }

    stages {

        stage(checkout) {
            // Cloning the source code from GitHub.
            steps {
                git branch: 'dev-branch', url: 'https://github.com/stephanemiafo/terraformforiam.git'
                echo 'Clonning the source code.'
            }
        }
    }
}