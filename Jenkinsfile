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
            echo "✅ Pipeline Execution Successful!"
            emailext(
                subject: "✅ Jenkins Job SUCCESS: ${env.JOB_NAME}",
                body: """
                    <html>
                        <body style="font-family:Arial, sans-serif; background-color:#f4f4f4; padding:20px;">
                            <div style="max-width:600px; background:white; padding:20px; border-radius:8px; box-shadow:0px 0px 10px rgba(0,0,0,0.1);">
                                <h2 style="color:#28a745;">✅ Jenkins Job SUCCESS</h2>
                                <p><strong>Job Name:</strong> ${env.JOB_NAME}</p>
                                <p><strong>Build Number:</strong> ${env.BUILD_NUMBER}</p>
                                <p>The Jenkins job has completed successfully. You can check the details by clicking the link below.</p>
                                <p><a href="${env.BUILD_URL}" style="color:#007bff; text-decoration:none; font-weight:bold;">View Build Logs</a></p>
                            </div>
                        </body>
                    </html>
                """,
                mimeType: 'text/html',
                to: 'saxenavardaan18@gmail.com'
            )
        }
        failure {
            echo "❌ Pipeline Execution Failed!"
            emailext(
                subject: "❌ Jenkins Job FAILED: ${env.JOB_NAME}",
                body: """
                    <html>
                        <body style="font-family:Arial, sans-serif; background-color:#f4f4f4; padding:20px;">
                            <div style="max-width:600px; background:white; padding:20px; border-radius:8px; box-shadow:0px 0px 10px rgba(0,0,0,0.1);">
                                <h2 style="color:#dc3545;">❌ Jenkins Job FAILED</h2>
                                <p><strong>Job Name:</strong> ${env.JOB_NAME}</p>
                                <p><strong>Build Number:</strong> ${env.BUILD_NUMBER}</p>
                                <p>The Jenkins job has failed. Please review the logs by clicking the link below.</p>
                                <p><a href="${env.BUILD_URL}" style="color:#007bff; text-decoration:none; font-weight:bold;">View Build Logs</a></p>
                            </div>
                        </body>
                    </html>
                """,
                mimeType: 'text/html',
                to: 'saxenavardaan18@gmail.com'
            )
        }
    }
}
