aws_region = "ap-south-1"
common_vars = {
  environment      = "development"
  application_name = "tf-aws-3-tier-infra"
  common_tags = {
    Project     = "tf-aws-3-tier-infra"
    Environment = "development"
    terraform   = "true"
    Owner       = "konka"
  }
}
vpc = {
  vpc_cidr_block            = "10.1.0.0/16"
  availability_zone         = ["ap-south-1a", "ap-south-1b"]
  public_subnet_cidr_blocks = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnet_cidr_blocks = ["10.1.11.0/24", "10.1.12.0/24"]
  db_subnet_cidr_blocks = ["10.1.21.0/24", "10.1.22.0/24"]
  enable_nat_gateway = true
  enable_vpc_flow_logs_cw = true
}

sg = {
  base_sg_name = "Bastion"
  bastion_sg_description = "Bastion SG"

  vpn_sg_name = "VPN"
  vpn_sg_description = "VPN SG"

  rds_sg_name = "RDS"
  rds_sg_description = "RDS SG"

  elastic_sg_name = "Elastic_Cache"
  elastic_sg_description = "Elastic_Cache SG"

  backend_sg_name = "Backend"
  backend_sg_description = "Backend SG"

  internal_alb_sg_name = "Internal-ALB"
  internal_alb_sg_description = "Internal SG"

  frontend_sg_name = "Frontend"
  frontend_sg_description = "Frontend SG"

  external_alb_sg_name = "External-ALB"
  external_alb_sg_description = "External_ALB SG"
}