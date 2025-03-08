provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "kafka_vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "kafka-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.kafka_vpc.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "public-subnet-1"
  }
}

# Private Subnets
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.kafka_vpc.id
  cidr_block        = "10.1.3.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.kafka_vpc.id
  cidr_block        = "10.1.4.0/24"
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

  # Allow SSH from anywhere
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
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

  # Allow SSH from Bastion Host
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    #security_groups = [aws_security_group.bastion_sg.id]
    cidr_blocks     = ["0.0.0.0/0"]
  }


  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# VPC Peering
resource "aws_vpc_peering_connection" "kafka_jenkins_peering" {
  vpc_id      = aws_vpc.kafka_vpc.id
  peer_vpc_id = "vpc-024bc9d9cadbcebc6"
  auto_accept = true
  tags = {
    Name = "kafka-jenkins-peering"
  }
}

# Route Table Updates
resource "aws_route" "kafka_to_jenkins" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "10.0.0.0/18"
  vpc_peering_connection_id = aws_vpc_peering_connection.kafka_jenkins_peering.id
  depends_on = [aws_vpc_peering_connection.kafka_jenkins_peering]
}

resource "aws_route" "jenkins_to_kafka" {
  route_table_id         = "rtb-089c5460f2a2ebec6"
  destination_cidr_block = "10.1.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.kafka_jenkins_peering.id
  depends_on = [aws_vpc_peering_connection.kafka_jenkins_peering]
}

# EC2 Instances
resource "aws_instance" "bastion" {
  ami                    = "ami-04b4f1a9cf54c11d0"
  instance_type          = "t2.micro"
  key_name               = "CommonKey"  
  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = { 
    Name = "Bastion Host"
    Role = "kafka"
  }

  provisioner "file" {
    source      = "/var/lib/jenkins/workspace/CommonKey.pem"
    destination = "/home/ubuntu/CommonKey.pem"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 400 /home/ubuntu/CommonKey.pem"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/var/lib/jenkins/workspace/CommonKey.pem")
    host        = self.public_ip
  }
}


resource "aws_instance" "kafka_instance_1" {
  ami                    = "ami-04b4f1a9cf54c11d0"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet_1.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = "CommonKey"
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
  key_name               = "CommonKey"
  tags = {
    Name = "kafka-instance-2"
    Role = "kafka"
  }
}
