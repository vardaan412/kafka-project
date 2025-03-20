# 🚀 Kafka One-Click Infrastructure  

## 🎯 Overview  
Kafka One-Click Infrastructure is an automated solution to set up a **Kafka cluster on AWS** using **Jenkins, Terraform, and Ansible**. This project simplifies Kafka deployment by provisioning AWS infrastructure, setting up networking, and installing Kafka across multiple private instances with a fully automated CI/CD pipeline.  

## 🏗️ Technologies Used  
To achieve a fully automated infrastructure setup, we utilized the following tools and services:  

### **1️⃣ Infrastructure Provisioning** (Terraform)  
- **Terraform**: Used to create AWS infrastructure.  
- **AWS Services**: VPC, EC2, S3, NAT Gateway, Internet Gateway, Security Groups, and VPC Peering.  
- **S3 Bucket**: Used for Terraform state file storage.  

### **2️⃣ Configuration Management** (Ansible)  
- **Ansible**: Used for Kafka installation on private EC2 instances.  
- **Bastion Host**: Acts as an intermediate to access private instances.  

### **3️⃣ CI/CD Automation** (Jenkins)  
- **Jenkins**: Automates the entire process by executing Terraform and Ansible playbooks.  
- **Jenkins Pipeline**: Ensures seamless infrastructure creation and configuration.  

## 📌 Infrastructure Details  
The project creates the following AWS resources:  

- **Virtual Private Clouds (VPCs)**  
  - **Kafka VPC** (Dedicated for Kafka instances)  
  - **Jenkins VPC** (For CI/CD pipeline execution)  

- **Subnets**  
  - **1 Public Subnets** (For Bastion Host and Jenkins)  
  - **2 Private Subnets** (For Kafka instances)  

- **Networking Components**  
  - **Public Route Table** (Routes internet traffic via Internet Gateway)  
  - **Private Route Table** (Routes traffic via NAT Gateway)  
  - **NAT Gateway** (Allows private instances to access the internet securely)  
  - **Internet Gateway** (Provides internet access to public instances)  
  - **VPC Peering** (Establishes communication between Kafka and Jenkins VPCs)  

- **Compute Resources**  
  - **1 Bastion Host** (Public EC2 instance to SSH into private instances)  
  - **6 Private Kafka Instances** (Kafka brokers deployed within a private subnet)  

- **Storage & State Management**  
  - **S3 Bucket** (Stores Terraform state files for consistency)  

## 🚀 Deployment Workflow  

### **Step 1: Infrastructure Provisioning (Terraform)**  
1. Terraform is used to **create all AWS resources**, including VPCs, subnets, security groups, and EC2 instances.  
2. A **Bastion Host** is launched in the public subnet to allow SSH access to private Kafka instances.  
3. **VPC Peering** is established between the Kafka VPC and Jenkins VPC to allow secure communication.  
4. A **Terraform backend S3 bucket** is created to store the state file for consistency.  

### **Step 2: Kafka Installation (Ansible)**  
1. **Ansible Playbook is executed from Jenkins** to configure Kafka on private instances.  
2. The playbook connects to the Kafka instances **via the Bastion Host** since direct access is restricted.  
3. **Kafka is installed and configured** on all 6 private instances.  

### **Step 3: Automation using Jenkins**  
1. **Jenkins triggers the Terraform workflow**, which provisions the entire AWS infrastructure.  
2. Once Terraform completes, **Jenkins triggers the Ansible playbook** for Kafka installation.  
3. The entire setup is completed in a **fully automated manner**.  

## 📝 Detailed Implementation  

### **1️⃣ Creating AWS Infrastructure with Terraform**  
The first step in the project was to **define the entire AWS infrastructure using Terraform**. We created two separate VPCs—one for Kafka and one for Jenkins.  

- The **Kafka VPC** contains 1 public and 2 private subnets.  
- The **Jenkins VPC** is separate to ensure isolation and security.  
- **VPC Peering** was configured to allow Jenkins to communicate with Kafka instances.  
- **Security Groups** were defined to restrict access to only required ports.  

Additionally, we set up an **S3 backend** for Terraform state management, ensuring consistency across deployments.  

### **2️⃣ Installing Kafka using Ansible**  
Since the Kafka instances were deployed in a **private subnet**, we needed a **Bastion Host** to manage them.  

- **Ansible roles** were created to install Kafka, configure brokers, and set up topics.  
- The playbook was executed via **Jenkins**, using the Bastion Host to connect to private instances.  
- Kafka was installed on **6 private instances**, ensuring a distributed architecture.  

### **3️⃣ Automating Everything with Jenkins**  
To make the entire process seamless, we used **Jenkins Pipelines** to trigger Terraform and Ansible automatically.  

- The pipeline starts by executing **Terraform to provision infrastructure**.  
- Once Terraform completes, Jenkins **runs the Ansible playbook** to install Kafka.  
- The entire process is automated, reducing manual effort and deployment time.  

## ✅ Key Features  
✅ **Fully automated Kafka deployment**  
✅ **Secure private Kafka setup with Bastion Host access**  
✅ **State management using S3 for consistency**  
✅ **CI/CD integration with Jenkins for seamless execution**  

**Happy Deploying! 🚀**  

