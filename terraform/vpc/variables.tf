variable "vpc_cidr" {
  default = "10.1.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.1.1.0/24"
}

variable "private_subnet_1_cidr" {
  default = "10.1.3.0/24"
}

variable "private_subnet_2_cidr" {
  default = "10.1.4.0/24"
}

variable "az_1" {
  default = "us-east-1a"
}

variable "az_2" {
  default = "us-east-1b"
}
