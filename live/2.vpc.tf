# VPC Module
module "vpc" {
  source                     = "../modules/vpc"
  environment                = var.common_vars["environment"]
  application_name           = var.common_vars["application_name"]
  common_tags                = var.common_vars["common_tags"]
  vpc_cidr_block             = var.vpc["vpc_cidr_block"]
  availability_zone          = var.vpc["availability_zone"]
  public_subnet_cidr_blocks  = var.vpc["public_subnet_cidr_blocks"]
  private_subnet_cidr_blocks = var.vpc["private_subnet_cidr_blocks"]
  db_subnet_cidr_blocks      = var.vpc["db_subnet_cidr_blocks"]
  enable_nat_gateway         = var.vpc["enable_nat_gateway"]
  enable_vpc_flow_logs_cw    = var.vpc["enable_vpc_flow_logs_cw"]
}

# VPC variables
variable "vpc" {}


# Outputs for VPC Module
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}
output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}
output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}
output "db_subnet_ids" {
  description = "List of database subnet IDs"
  value       = module.vpc.db_subnet_ids
}
output "db_subnet_group_name" {
  description = "The name of the DB subnet group"
  value       = module.vpc.db_subnet_group_name
}
