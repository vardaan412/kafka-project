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

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/vardaan412/kafka-project.git'
            }
        }

        stage('Terraform Init') {
            steps {
                dir(TF_WORKING_DIR) {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir(TF_WORKING_DIR) {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir(TF_WORKING_DIR) {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { env.USER_ACTION == 'Build' }
            }
            steps {
                dir(TF_WORKING_DIR) {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { env.USER_ACTION == 'Destroy' }
            }
            steps {
                dir(TF_WORKING_DIR) {
                    sh 'terraform destroy -auto-approve'
                }
            }
        }

        stage('Wait for Instances (if Build)') {
            when {
                expression { env.USER_ACTION == 'Build' }
            }
            steps {
                script {
                    echo "⏳ Waiting for EC2 instances to be ready..."
                    sleep(time: 60, unit: 'SECONDS')
                }
            }
        }

        stage('Check Ansible Inventory') {
            when {
                expression { env.USER_ACTION == 'Build' }
            }
            steps {
                sh '''
                cd ansible
                ls -l aws_ec2.yml  # Debugging: Ensure inventory file exists
                ansible-inventory -i aws_ec2.yml --list
                '''
            }
        }

        stage('Install Dependencies on Managed Nodes') {
            when {
                expression { env.USER_ACTION == 'Build' }
            }
            steps {
                sh '''
                cd ansible
                ansible all -i aws_ec2.yml -m raw -a "apt update -y && apt install -y python3 python3-six" --become
                '''
            }
        }

        stage('Run Ansible Playbook') {
            when {
                expression { env.USER_ACTION == 'Build' }
            }
            steps {
                sh '''
                cd ansible
                ansible-playbook -i aws_ec2.yml kafka-playbook.yml
                '''
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
                    to: 'saxenavardaan18@gmail.com'
                )
            }
        }
    }
}
