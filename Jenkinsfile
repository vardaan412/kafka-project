pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/vardaan412/kafka-project.git'
            }
        }

        stage('Run GitLeaks Security Scan') {
            steps {
                sh '''
                echo "🔍 Running GitLeaks security scan..."
                gitleaks detect -v --source . --exit-code 1
                '''
            }
        }
    }

    post {
        success {
            script {
                def emailBody = """
                <html>
                    <body style="font-family: Arial, sans-serif; background-color: #F4F4F4; padding: 20px;">
                        <div style="max-width: 600px; margin: auto; background-color: #D4EDDA; padding: 20px; border-left: 5px solid #28A745; border-radius: 5px;">
                            <h2 style="color: #155724;">✅ Jenkins Job SUCCESS</h2>
                            <p style="color: #155724; font-size: 16px;">
                                <strong>Job Name:</strong> ${env.JOB_NAME} <br>
                                <strong>Build No:</strong> ${env.BUILD_NUMBER} <br>
                                <strong>Triggered By:</strong> ${currentBuild.getBuildCauses().shortDescription}
                            </p>
                            <p style="color: #155724; font-size: 16px;">The job has completed successfully. 🎉</p>
                            <p style="color: #155724; font-size: 16px;"><strong>Check logs here:</strong>
                                <a href="${env.BUILD_URL}" style="color:#155724; text-decoration:none; font-weight:bold;">Click Here To View Build Logs</a>
                            </p>
                        </div>
                    </body>
                </html>
                """
                emailext(
                    mimeType: 'text/html',
                    subject: "✅ SUCCESS: ${env.JOB_NAME} (Build #${env.BUILD_NUMBER})",
                    body: emailBody,
                    to: 'saxenavardaan18@gmail.com'
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
                                <strong>Build No:</strong> ${env.BUILD_NUMBER} <br>
                                <strong>Triggered By:</strong> ${currentBuild.getBuildCauses().shortDescription}
                            </p>
                            <p style="color: #721c24; font-size: 16px; font-weight: bold;">The job has failed. ❌</p>
                            <p style="color: #721c24; font-size: 16px;"><strong>Check logs here:</strong> 
                                <a href="${env.BUILD_URL}" style="color:#721c24; text-decoration:none; font-weight:bold;">Click Here To View Build Logs</a>
                            </p>
                        </div>
                    </body>
                </html>
                """
                emailext(
                    mimeType: 'text/html',
                    subject: "❌ FAILED: ${env.JOB_NAME} (Build #${env.BUILD_NUMBER})",
                    body: emailBody,
                    to: 'saxenavardaan18@gmail.com'
                )
            }
        }
    }
}
