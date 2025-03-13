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
                ansible-playbook -i aws_ec2.yml kafka-playbook.yml -vv  # Add verbosity for debugging
                '''
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
