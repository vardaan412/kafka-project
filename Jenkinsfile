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
                subject: "✅ Jenkins Job SUCCESS", 
                body: """
                    <html>
                        <body style="font-family:Arial, sans-serif; background-color:#e3fcef; padding:20px;">
                            <div style="max-width:600px; background:white; padding:20px; border-radius:8px; box-shadow:0px 0px 10px rgba(0,0,0,0.1); text-align:center;">
                                <h1 style="color:#28a745;">✅ SUCCESS</h1>
                                <p style="font-size:18px; color:#333;">The Jenkins job has been successfully completed.</p>
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
                subject: "❌ Jenkins Job FAILED", 
                body: """
                    <html>
                        <body style="font-family:Arial, sans-serif; background-color:#fdecea; padding:20px;">
                            <div style="max-width:600px; background:white; padding:20px; border-radius:8px; box-shadow:0px 0px 10px rgba(0,0,0,0.1); text-align:center;">
                                <h1 style="color:#dc3545;">❌ FAILED</h1>
                                <p style="font-size:18px; color:#333;">The Jenkins job has failed.</p>
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
