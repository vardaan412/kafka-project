# 🚀 Kafka One-Click Infrastructure

## 🎯 Overview
**Kafka One-Click Infrastructure** is an automated deployment solution that provisions a complete Kafka setup using **Jenkins, Terraform, and Ansible**. This project automates the creation of AWS infrastructure, configures networking, and installs Kafka across multiple instances seamlessly.

## 🏗️ Technologies Used
- **Terraform**: Infrastructure as Code (IaC) to provision AWS resources.
- **Jenkins**: CI/CD pipeline to orchestrate infrastructure deployment and configuration management.
- **Ansible**: Automates Kafka installation and configuration.
- **AWS Services**: VPC, EC2, S3, Security Groups, NAT Gateway, Internet Gateway, and VPC Peering.

## 📌 Infrastructure Architecture
The project provisions the following AWS resources:
- **VPC**: Dedicated Kafka VPC.
- **Subnets**: 
  - 2 Public Subnets
  - 2 Private Subnets
- **Route Tables**:
  - Public Route Table
  - Private Route Table
- **Networking Components**:
  - NAT Gateway
  - Internet Gateway
  - VPC Peering (for communication between Kafka VPC and Jenkins VPC)
- **EC2 Instances**:
  - **1 Bastion Host** (Public Instance for SSH access)
  - **6 Private Kafka Instances** (Kafka Brokers)
- **Terraform State Management**:
  - **S3 Bucket** to store Terraform state files.
  - **State Locking** to prevent concurrent modifications.

## 🔧 Deployment Workflow
### 1️⃣ Provisioning Infrastructure with Terraform
- **Jenkins Pipeline** triggers Terraform scripts.
- Terraform provisions the entire AWS infrastructure.
- The Terraform state file is stored in an **S3 bucket**.

### 2️⃣ Configuring Kafka with Ansible
- **VPC Peering** is established between **Kafka VPC** and **Jenkins VPC**.
- Ansible connects to **private Kafka instances** via **bastion host**.
- Ansible installs and configures Kafka on all 6 private instances.

### 3️⃣ Jenkins Automation
- Jenkins executes the Terraform scripts.
- Once Terraform completes provisioning, Jenkins triggers Ansible playbooks.
- Ansible remotely installs and configures Kafka.
