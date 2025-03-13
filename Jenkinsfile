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
                        choice(
                            name: 'ACTION', 
                            choices: ['Build', 'Destroy'], 
                            description: 'Choose whether to build or destroy infrastructure'
                        )
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
                <body style="font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 20px;">
                    <div style="max-width: 600px; margin: auto; background-color: #d4edda; padding: 20px; border-left: 5px solid #28a745; border-radius: 5px;">
                        <h2 style="color: #155724;">✅ Jenkins Job SUCCESS</h2>
                        <p style="color: #155724; font-size: 16px;">
                            <strong>Job Name:</strong> ${env.JOB_NAME} <br>
                            <strong>Build No:</strong> ${env.BUILD_NUMBER}
                        </p>
                        <p style="font-size: 14px;">The job has completed successfully. 🎉</p>
                    </div>
                </body>
                </html>
                """
                emailext(
                    mimeType: 'text/html',
                    subject: "✅ SUCCESS: ${env.JOB_NAME} (Build #${env.BUILD_NUMBER})",
                    body: emailBody,
                    to: 'saxenavardaan18@gmail.com' // Replace with actual recipient email
                )
            }
        }

        failure {
            script {
                def emailBody = """
                <html>
                <body style="font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 20px;">
                    <div style="max-width: 600px; margin: auto; background-color: #f8d7da; padding: 20px; border-left: 5px solid #dc3545; border-radius: 5px;">
                        <h2 style="color: #721c24;">❌ Jenkins Job FAILED</h2>
                        <p style="color: #721c24; font-size: 16px;">
                            <strong>Job Name:</strong> ${env.JOB_NAME} <br>
                            <strong>Build No:</strong> ${env.BUILD_NUMBER}
                        </p>
                        <p style="font-size: 14px;">Please check the Jenkins console logs for more details.</p>
                    </div>
                </body>
                </html>
                """
                emailext(
                    mimeType: 'text/html',
                    subject: "❌ FAILED: ${env.JOB_NAME} (Build #${env.BUILD_NUMBER})",
                    body: emailBody,
                    to: 'saxenavardaan18@gmail.com' // Replace with actual recipient email
                )
            }
        }
    }
}
