provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "kafka_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "kafka-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.kafka_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "public-subnet-1"
  }
}

# Private Subnets
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.kafka_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.kafka_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "private-subnet-2"
  }
}

# Internet Gateway for Public Subnet
resource "aws_internet_gateway" "kafka_igw" {
  vpc_id = aws_vpc.kafka_vpc.id
  tags = {
    Name = "kafka-igw"
  }
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.kafka_vpc.id
  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.kafka_igw.id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

# NAT Gateway for Private Subnets
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id
  tags = {
    Name = "nat-gateway"
  }
}

# Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.kafka_vpc.id
  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route" "private_nat_gateway_access" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

resource "aws_route_table_association" "private_assoc_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_assoc_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}

# Security Groups
resource "aws_security_group" "bastion_sg" {
  vpc_id = aws_vpc.kafka_vpc.id
  tags = {
    Name = "bastion-sg"
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.kafka_vpc.id
  tags = {
    Name = "private-sg"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.public_subnet_1.cidr_block]
  }
  
  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  ingress {
    from_port   = 2181
    to_port     = 2181
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "bastion" {
  ami                    = "ami-04b4f1a9cf54c11d0"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  key_name               = "Commonkey"   # Using the same key name

  user_data = <<-EOF
    #!/bin/bash
    mkdir -p /home/ubuntu/.ssh

    # Generate SSH keypair dynamically
    ssh-keygen -t rsa -b 2048 -f /home/ubuntu/.ssh/Commonkey -q -N ""

    # Ensure correct permissions
    chmod 700 /home/ubuntu/.ssh
    chmod 600 /home/ubuntu/.ssh/Commonkey
    chmod 644 /home/ubuntu/.ssh/Commonkey.pub
    chown -R ubuntu:ubuntu /home/ubuntu/.ssh
  EOF

  tags = {
    Name = "Bastion Host"
  }
}

output "bastion_public_key" {
  value = file("${path.module}/Commonkey.pub")
}
resource "aws_instance" "kafka_instance_1" {
  ami                    = "ami-04b4f1a9cf54c11d0"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet_1.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = "Commonkey"  # Using the same key name

  user_data = <<-EOF
    #!/bin/bash
    mkdir -p /home/ubuntu/.ssh

    # Fetch the public key from Bastion
    echo "${file("${path.module}/Commonkey.pub")}" > /home/ubuntu/.ssh/authorized_keys

    chmod 700 /home/ubuntu/.ssh
    chmod 600 /home/ubuntu/.ssh/authorized_keys
    chown -R ubuntu:ubuntu /home/ubuntu/.ssh
  EOF

  tags = {
    Name = "kafka-instance-1"
    Role = "kafka"
  }
}


resource "aws_instance" "kafka_instance_2" {
  ami                    = "ami-04b4f1a9cf54c11d0"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet_2.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = "Commonkey"  # Using the same key name

  user_data = <<-EOF
    #!/bin/bash
    mkdir -p /home/ubuntu/.ssh

    # Fetch the public key from Bastion
    echo "${file("${path.module}/Commonkey.pub")}" > /home/ubuntu/.ssh/authorized_keys

    chmod 700 /home/ubuntu/.ssh
    chmod 600 /home/ubuntu/.ssh/authorized_keys
    chown -R ubuntu:ubuntu /home/ubuntu/.ssh
  EOF

  tags = {
    Name = "kafka-instance-2"
    Role = "kafka"
  }
}
