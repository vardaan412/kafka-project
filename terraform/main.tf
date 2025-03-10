provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

module "vpc_peering" {
  source                 = "./modules/vpc_peering"
  vpc_id                 = module.vpc.vpc_id
  private_route_table_id = module.vpc.private_route_table_id
}

module "ec2" {
  source               = "./modules/ec2"
  public_subnet_id     = module.vpc.public_subnet_id
  private_subnet_1_id  = module.vpc.private_subnet_1_id
  private_subnet_2_id  = module.vpc.private_subnet_2_id
  bastion_sg_id        = module.security_groups.bastion_sg_id
  private_sg_id        = module.security_groups.private_sg_id
}
