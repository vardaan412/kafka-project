pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        TF_WORKING_DIR = 'terraform'
        TF_STATE_FILE = 'terraform/terraform.tfstate'
        ANSIBLE_HOST_KEY_CHECKING = 'False'
        PATH = "/home/ubuntu/.local/bin:$PATH"
    }

    stages {
        stage('User Input') {
            steps {
                script {
                    def userChoice = input message: 'Select Action:', parameters: [
                        choice(name: 'ACTION', choices: ['Build', 'Destroy'], description: 'Choose whether to build or destroy infrastructure')
                    ]
                    env.USER_ACTION = userChoice
                }
            }
        }
    }

    post {
        success {
            script {
                def emailBody = """
                <html>
                <body style='background-color:#d4edda; padding:20px; font-family:Arial, sans-serif;'>
                    <h2 style='color:#155724;'>✅ Jenkins Job SUCCESS</h2>
                    <p style='color:#155724; font-size:16px;'>The Jenkins job <b>${env.JOB_NAME}</b> (Build #${env.BUILD_NUMBER}) has been completed successfully.</p>
                </body>
                </html>
                """
                emailext(
                    mimeType: 'text/html',
                    subject: "✅ Jenkins Job SUCCESS: ${env.JOB_NAME} (#${env.BUILD_NUMBER})",
                    body: emailBody,
                    recipientProviders: [[$class: 'CulpritsRecipientProvider'], [$class: 'RequesterRecipientProvider']],
                    from: 'jenkins@support.com'
                )
            }
        }
        failure {
            script {
                def emailBody = """
                <html>
                <body style='background-color:#f8d7da; padding:20px; font-family:Arial, sans-serif;'>
                    <h2 style='color:#721c24;'>❌ Jenkins Job FAILED</h2>
                    <p style='color:#721c24; font-size:16px;'>The Jenkins job <b>${env.JOB_NAME}</b> (Build #${env.BUILD_NUMBER}) has failed.</p>
                </body>
                </html>
                """
                emailext(
                    mimeType: 'text/html',
                    subject: "❌ Jenkins Job FAILED: ${env.JOB_NAME} (#${env.BUILD_NUMBER})",
                    body: emailBody,
                    recipientProviders: [[$class: 'CulpritsRecipientProvider'], [$class: 'RequesterRecipientProvider']],
                    from: 'jenkins@support.com'
                )
            }
        }
    }
}
