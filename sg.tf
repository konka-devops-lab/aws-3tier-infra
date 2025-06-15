# SG and SG Rules
module "bastion_sg" {
  source                    = "./modules/sg"
  environment               = var.common_vars["environment"]
  application_name          = var.common_vars["application_name"]
  common_tags               = var.common_vars["common_tags"]
  vpc_id                    = module.vpc.vpc_id
  sg_name                  = var.sg["bastion_sg_name"]
  sg_description           = var.sg["bastion_sg_description"]
}
module "vpn_sg" {
  source                    = "./modules/sg"
  environment               = var.common_vars["environment"]
  application_name          = var.common_vars["application_name"]
  common_tags               = var.common_vars["common_tags"]
  vpc_id                    = module.vpc.vpc_id
  sg_name                  = var.sg["vpn_sg_name"]
  sg_description           = var.sg["vpn_sg_description"]
}
module "rds_sg" {
  source                    = "./modules/sg"
  environment               = var.common_vars["environment"]
  application_name          = var.common_vars["application_name"]
  common_tags               = var.common_vars["common_tags"]
  vpc_id                    = module.vpc.vpc_id
  sg_name                  = var.sg["rds_sg_name"]
  sg_description           = var.sg["rds_sg_description"]
}

module "elastic_cache_sg" {
  source                    = "./modules/sg"
  environment               = var.common_vars["environment"]
  application_name          = var.common_vars["application_name"]
  common_tags               = var.common_vars["common_tags"]
  vpc_id                    = module.vpc.vpc_id
  sg_name                  = var.sg["elastic_cache_sg_name"]
  sg_description           = var.sg["elastic_cache_sg_description"]
}
module "backend_sg" {
  source                    = "./modules/sg"
  environment               = var.common_vars["environment"]
  application_name          = var.common_vars["application_name"]
  common_tags               = var.common_vars["common_tags"]
  vpc_id                    = module.vpc.vpc_id
  sg_name                  = var.sg["backend_sg_name"]
  sg_description           = var.sg["backend_sg_description"]
}
module "internal_alb_sg" {
  source                    = "./modules/sg"
  environment               = var.common_vars["environment"]
  application_name          = var.common_vars["application_name"]
  common_tags               = var.common_vars["common_tags"]
  vpc_id                    = module.vpc.vpc_id
  sg_name                  = var.sg["internal_alb_sg_name"]
  sg_description           = var.sg["internal_alb_sg_description"]
}
module "external_alb_sg" {
  source                    = "./modules/sg"
  environment               = var.common_vars["environment"]
  application_name          = var.common_vars["application_name"]
  common_tags               = var.common_vars["common_tags"]
  vpc_id                    = module.vpc.vpc_id
  sg_name                  = var.sg["external_alb_sg_name"]
  sg_description           = var.sg["external_alb_sg_description"]
}
module "frontend_sg" {
  source                    = "./modules/sg"
  environment               = var.common_vars["environment"]
  application_name          = var.common_vars["application_name"]
  common_tags               = var.common_vars["common_tags"]
  vpc_id                    = module.vpc.vpc_id
  sg_name                  = var.sg["frontend_sg_name"]
  sg_description           = var.sg["frontend_sg_description"]
}

# Bastion SG Rules
resource "aws_security_group_rule" "example" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion_sg.sg_id
  description       = "Allow SSH access from anywhere"
  depends_on        = [module.bastion_sg]
}

# VPN SG Rules
resource "aws_security_group_rule" "vpn_ssh" {
  description       = "This rule allows all traffic from internet on 22"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn_sg.sg_id
}
resource "aws_security_group_rule" "vpn_https" {
  description       = "This rule allows all traffic from internet on 443"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn_sg.sg_id
}
resource "aws_security_group_rule" "vpn_et" {
  description       = "This rule allows all traffic from internet on 943"
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn_sg.sg_id
}
resource "aws_security_group_rule" "vpn_udp" {
  description       = "This rule allows all traffic from internet on 1194"
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn_sg.sg_id
}

# RDS Rules
resource "aws_security_group_rule" "vpn_rds" {
  description       = "This rule allows all traffic from 3306 from VPN"
  type              = "ingress"
  from_port         = 3306
  to_port           = 3006
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id  
  security_group_id = module.rds_sg.sg_id
}