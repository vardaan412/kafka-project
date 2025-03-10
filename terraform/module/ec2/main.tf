resource "aws_instance" "bastion" {
  ami                    = var.ami_id
  instance_type          = var.bastion_instance_type
  key_name               = var.key_name
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.bastion_sg_id]

  tags = {
    Name = "Bastion Host"
  }

  provisioner "file" {
    source      = var.key_file_path
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
    private_key = file(var.key_file_path)
    host        = self.public_ip
  }
}

# Kafka Instances
resource "aws_instance" "kafka_instance_1" {
  ami                    = var.ami_id
  instance_type          = var.kafka_instance_type
  subnet_id              = var.private_subnet_1_id
  vpc_security_group_ids = [var.private_sg_id]
  key_name               = var.key_name
  tags = {
    Name = "kafka-instance-1"
    Role = "kafka"
  }
}
resource "aws_instance" "kafka_instance_2" {
  ami                    = var.ami_id
  instance_type          = var.kafka_instance_type
  subnet_id              = var.private_subnet_1_id
  vpc_security_group_ids = [var.private_sg_id]
  key_name               = var.key_name
  tags = {
    Name = "kafka-instance-2"
    Role = "kafka"
  }
}
resource "aws_instance" "kafka_instance_3" {
  ami                    = var.ami_id
  instance_type          = var.kafka_instance_type
  subnet_id              = var.private_subnet_1_id
  vpc_security_group_ids = [var.private_sg_id]
  key_name               = var.key_name
  tags = {
    Name = "kafka-instance-3"
    Role = "kafka"
  }
}
resource "aws_instance" "kafka_instance_4" {
  ami                    = var.ami_id
  instance_type          = var.kafka_instance_type
  subnet_id              = var.private_subnet_2_id
  vpc_security_group_ids = [var.private_sg_id]
  key_name               = var.key_name
  tags = {
    Name = "kafka-instance-4"
    Role = "kafka"
  }
}
resource "aws_instance" "kafka_instance_5" {
  ami                    = var.ami_id
  instance_type          = var.kafka_instance_type
  subnet_id              = var.private_subnet_2_id
  vpc_security_group_ids = [var.private_sg_id]
  key_name               = var.key_name
  tags = {
    Name = "kafka-instance-5"
    Role = "kafka"
  }
}
resource "aws_instance" "kafka_instance_6" {
  ami                    = var.ami_id
  instance_type          = var.kafka_instance_type
  subnet_id              = var.private_subnet_2_id
  vpc_security_group_ids = [var.private_sg_id]
  key_name               = var.key_name
  tags = {
    Name = "kafka-instance-6"
    Role = "kafka"
  }
}
