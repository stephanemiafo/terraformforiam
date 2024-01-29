pipeline {

    agent any

    stages {
        stage(checkout) {
            // Cloning the source code from GitHub.
            steps {
                git branch: 'dev-branch', url: 'https://github.com/stephanemiafo/terraformforiam.git'
            }
        }
    }
}