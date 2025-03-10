variable "ami_id" {
  default = "ami-04b4f1a9cf54c11d0"
}

variable "bastion_instance_type" {
  default = "t2.micro"
}

variable "kafka_instance_type" {
  default = "t2.large"
}

variable "public_subnet_id" {}
variable "private_subnet_1_id" {}
variable "private_subnet_2_id" {}
variable "bastion_sg_id" {}
variable "private_sg_id" {}
variable "key_name" {
  default = "CommonKey"
}
variable "key_file_path" {
  default = "/var/lib/jenkins/workspace/CommonKey.pem"
}
