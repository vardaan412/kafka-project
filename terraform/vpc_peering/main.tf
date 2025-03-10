resource "aws_vpc_peering_connection" "kafka_jenkins_peering" {
  vpc_id      = var.vpc_id
  peer_vpc_id = var.peer_vpc_id
  auto_accept = true
  tags = {
    Name = "kafka-jenkins-peering"
  }
}

resource "aws_route" "kafka_to_jenkins" {
  route_table_id            = var.private_route_table_id
  destination_cidr_block    = "10.0.0.0/18"
  vpc_peering_connection_id = aws_vpc_peering_connection.kafka_jenkins_peering.id
  depends_on                = [aws_vpc_peering_connection.kafka_jenkins_peering]
}

resource "aws_route" "jenkins_to_kafka" {
  route_table_id            = var.peer_route_table_id
  destination_cidr_block    = "10.1.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.kafka_jenkins_peering.id
  depends_on                = [aws_vpc_peering_connection.kafka_jenkins_peering]
}
