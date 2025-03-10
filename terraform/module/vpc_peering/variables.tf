variable "vpc_id" {}
variable "peer_vpc_id" {
  default = "vpc-024bc9d9cadbcebc6"  # Hardcoded as per your original code
}
variable "private_route_table_id" {}
variable "peer_route_table_id" {
  default = "rtb-089c5460f2a2ebec6"  # Hardcoded as per your original code
}
