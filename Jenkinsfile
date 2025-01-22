pipeline {
    agent any
    environment {
        SF_USERNAME_ORG1 = credentials('sf-username-org1')   // Org 1 Salesforce credentials
        SF_USERNAME_ORG2 = credentials('sf-username-org2')   // Org 2 Salesforce credentials
        SF_PASSWORD = credentials('sf-password')             // Salesforce password
        SF_SECURITY_TOKEN = credentials('sf-security-token') // Salesforce security token
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Deploy to Org 1') {
            steps {
                script {
                    // Deploy changes to Org 1 (for example, using Salesforce CLI)
                    sh 'sfdx force:source:deploy -p force-app/main/default -u $SF_USERNAME_ORG1'
                }
            }
        }

        stage('Approval') {
            steps {
                script {
                    // Wait for manual approval to continue to Org 2 deployment
                    input message: 'Approve deployment to Org 2?', ok: 'Approve'
                }
            }
        }
        
        stage('Deploy to Org 2') {
            steps {
                script {
                    // Deploy to Org 2 after approval
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
