pipeline {
    agent any

    environment {
        // Salesforce Org 1 credentials (GitHub secrets or Jenkins credentials)
        SF_USERNAME_ORG1 = credentials('Mule@atman.sandbox')  // Org 1 Salesforce username
        SF_USERNAME_ORG2 = credentials('employees@atman.in')  // Org 2 Salesforce username
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm  // Pull latest changes from GitHub
            }
        }

        stage('Deploy to Org 1') {
            steps {
                script {
                    // Deploy changes to Org 1 (Salesforce CLI)
                    sh 'sfdx force:source:deploy -p force-app/main/default -u $SF_USERNAME_ORG1'
                }
            }
        }

        stage('Approval') {
            steps {
                script {
                    // Wait for manual approval before deploying to Org 2
                    input message: 'Approve deployment to Org 2?', ok: 'Approve'
                }
            }
        }

        stage('Deploy to Org 2') {
            steps {
                script {
                    // Deploy changes to Org 2 (Salesforce CLI)
                    sh 'sfdx force:source:deploy -p force-app/main/default -u $SF_USERNAME_ORG2'
                }
            }
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
