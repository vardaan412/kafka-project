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
                body: "Jenkins job '${env.JOB_NAME}' (Build #${env.BUILD_NUMBER}) completed successfully.\nCheck logs here: ${env.BUILD_URL}",
                to: 'saxenavardaan18@gmail.com'
            )
        }
        failure {
            echo "❌ Pipeline Execution Failed!"
            emailext(
                subject: "❌ Jenkins Job FAILED: ${env.JOB_NAME}",
                body: "Jenkins job '${env.JOB_NAME}' (Build #${env.BUILD_NUMBER}) failed.\nCheck logs here: ${env.BUILD_URL}",
                to: 'saxenavardaan18@gmail.com'
            )
        }
    }
}
