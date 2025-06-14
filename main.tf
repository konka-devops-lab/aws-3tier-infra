module "vpc" {
  source                    = "./modules/vpc"
  environment               = var.common_vars["environment"]
  application_name          = var.common_vars["application_name"]
  common_tags               = var.common_vars["common_tags"]
  vpc_cidr_block            = var.vpc["vpc_cidr_block"]
  public_subnet_cidr_blocks = var.vpc["public_subnet_cidr_blocks"]
  availability_zone         = var.vpc["availability_zone"]
}