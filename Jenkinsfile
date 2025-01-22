pipeline {
    agent any
    
    environment {
        SF_USERNAME = credentials('Mule@atman.sandbox')  // You can keep this environment variable if you plan to use it in some other step
    }

    stages {
        stage('Checkout Code') {
            steps {
                git credentialsId: 'Github_orgCode', url: 'https://github.com/professorchavan/OrgCode.git'
            }
        }

        

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed.'
        }
    }
}
