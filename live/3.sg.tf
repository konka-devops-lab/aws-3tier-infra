# SG and SG Rules
module "bastion_sg" {
  source           = "../modules/sg"
  environment      = var.common_vars["environment"]
  application_name = var.common_vars["application_name"]
  common_tags      = var.common_vars["common_tags"]
  vpc_id           = module.vpc.vpc_id
  sg_name          = var.sg["bastion_sg_name"]
  sg_description   = var.sg["bastion_sg_description"]
}
# module "vpn_sg" {
#   source           = "../modules/sg"
#   environment      = var.common_vars["environment"]
#   application_name = var.common_vars["application_name"]
#   common_tags      = var.common_vars["common_tags"]
#   vpc_id           = module.vpc.vpc_id
#   sg_name          = var.sg["vpn_sg_name"]
#   sg_description   = var.sg["vpn_sg_description"]
# }
module "rds_sg" {
  source           = "../modules/sg"
  environment      = var.common_vars["environment"]
  application_name = var.common_vars["application_name"]
  common_tags      = var.common_vars["common_tags"]
  vpc_id           = module.vpc.vpc_id
  sg_name          = var.sg["rds_sg_name"]
  sg_description   = var.sg["rds_sg_description"]
}

module "elastic_cache_sg" {
  source           = "../modules/sg"
  environment      = var.common_vars["environment"]
  application_name = var.common_vars["application_name"]
  common_tags      = var.common_vars["common_tags"]
  vpc_id           = module.vpc.vpc_id
  sg_name          = var.sg["elastic_cache_sg_name"]
  sg_description   = var.sg["elastic_cache_sg_description"]
}
module "backend_sg" {
  source           = "../modules/sg"
  environment      = var.common_vars["environment"]
  application_name = var.common_vars["application_name"]
  common_tags      = var.common_vars["common_tags"]
  vpc_id           = module.vpc.vpc_id
  sg_name          = var.sg["backend_sg_name"]
  sg_description   = var.sg["backend_sg_description"]
}
module "internal_alb_sg" {
  source           = "../modules/sg"
  environment      = var.common_vars["environment"]
  application_name = var.common_vars["application_name"]
  common_tags      = var.common_vars["common_tags"]
  vpc_id           = module.vpc.vpc_id
  sg_name          = var.sg["internal_alb_sg_name"]
  sg_description   = var.sg["internal_alb_sg_description"]
}
module "external_alb_sg" {
  source           = "../modules/sg"
  environment      = var.common_vars["environment"]
  application_name = var.common_vars["application_name"]
  common_tags      = var.common_vars["common_tags"]
  vpc_id           = module.vpc.vpc_id
  sg_name          = var.sg["external_alb_sg_name"]
  sg_description   = var.sg["external_alb_sg_description"]
}
module "frontend_sg" {
  source           = "../modules/sg"
  environment      = var.common_vars["environment"]
  application_name = var.common_vars["application_name"]
  common_tags      = var.common_vars["common_tags"]
  vpc_id           = module.vpc.vpc_id
  sg_name          = var.sg["frontend_sg_name"]
  sg_description   = var.sg["frontend_sg_description"]
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

# # VPN SG Rules
# resource "aws_security_group_rule" "vpn_ssh" {
#   description       = "This rule allows all traffic from internet on 22"
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = module.vpn_sg.sg_id
# }
# resource "aws_security_group_rule" "vpn_https" {
#   description       = "This rule allows all traffic from internet on 443"
#   type              = "ingress"
#   from_port         = 443
#   to_port           = 443
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = module.vpn_sg.sg_id
# }
# resource "aws_security_group_rule" "vpn_et" {
#   description       = "This rule allows all traffic from internet on 943"
#   type              = "ingress"
#   from_port         = 943
#   to_port           = 943
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = module.vpn_sg.sg_id
# }
# resource "aws_security_group_rule" "vpn_udp" {
#   description       = "This rule allows all traffic from internet on 1194"
#   type              = "ingress"
#   from_port         = 1194
#   to_port           = 1194
#   protocol          = "udp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = module.vpn_sg.sg_id
# }

# # RDS Rules
# resource "aws_security_group_rule" "vpn_rds" {
#   description              = "This rule allows all traffic from 3306 from VPN"
#   type                     = "ingress"
#   from_port                = 3306
#   to_port                  = 3306
#   protocol                 = "tcp"
#   source_security_group_id = module.vpn_sg.sg_id
#   security_group_id        = module.rds_sg.sg_id
# }
resource "aws_security_group_rule" "bastion_rds" {
  description              = "This rule allows all traffic from 3306 from bastion"
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id        = module.rds_sg.sg_id
}

resource "aws_security_group_rule" "backend_rds" {
  description              = "This rule allows all traffic from 3306 from Backend"
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.backend_sg.sg_id
  security_group_id        = module.rds_sg.sg_id
}

# Elastic Cache Rules
resource "aws_security_group_rule" "bastion_elasticache" {
  description              = "This rule allows all traffic from 3306 from Bastion"
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id        = module.elastic_cache_sg.sg_id
}

resource "aws_security_group_rule" "backend_elasticache" {
  description              = "This rule allows all traffic from 3306 from Backend"
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = module.backend_sg.sg_id
  security_group_id        = module.elastic_cache_sg.sg_id
}

# Backend SG Rules
# resource "aws_security_group_rule" "vpn_backend" {
#   description              = "This rule allows all traffic from 8080 from vpn"
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   source_security_group_id = module.vpn_sg.sg_id
#   security_group_id        = module.backend_sg.sg_id
# }

resource "aws_security_group_rule" "bastion_backend" {
  description              = "This rule allows all traffic from 8080 from bastion"
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id        = module.backend_sg.sg_id
}
resource "aws_security_group_rule" "internal_alb_backend" {
  description              = "This rule allows all traffic from 8080 from internal_alb_sg"
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.internal_alb_sg.sg_id
  security_group_id        = module.backend_sg.sg_id
}

# Internal ALB SG Rules
# resource "aws_security_group_rule" "vpn_internal_alb" {
#   description              = "This rule allows all traffic from 80 from vpn"
#   type                     = "ingress"
#   from_port                = 80
#   to_port                  = 80
#   protocol                 = "tcp"
#   source_security_group_id = module.vpn_sg.sg_id
#   security_group_id        = module.internal_alb_sg.sg_id
# }
resource "aws_security_group_rule" "bastion_internal_alb" {
  description              = "This rule allows all traffic from 80 from bastion"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id        = module.internal_alb_sg.sg_id
}
resource "aws_security_group_rule" "frontend_internal_alb" {
  description              = "This rule allows all traffic from 80 from fronend"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.frontend_sg.sg_id
  security_group_id        = module.internal_alb_sg.sg_id
}
# Frotend SG Rules
# resource "aws_security_group_rule" "vpn_frontend" {
#   description              = "This rule allows all traffic from 80 from vpn"
#   type                     = "ingress"
#   from_port                = 80
#   to_port                  = 80
#   protocol                 = "tcp"
#   source_security_group_id = module.vpn_sg.sg_id
#   security_group_id        = module.frontend_sg.sg_id
# }
resource "aws_security_group_rule" "bastion_frontend" {
  description              = "This rule allows all traffic from 80 from bastion"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id        = module.frontend_sg.sg_id
}
resource "aws_security_group_rule" "external_alb_frontend" {
  description              = "This rule allows all traffic from 80 from external_alb"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.external_alb_sg.sg_id
  security_group_id        = module.frontend_sg.sg_id
}
# External ALB SG Rules
resource "aws_security_group_rule" "http_external_external_alb" {
  description       = "This rule allows all traffic from 80 from http_external"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.external_alb_sg.sg_id
}
resource "aws_security_group_rule" "https_external_external_alb" {
  description       = "This rule allows all traffic from 80 from https_external"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.external_alb_sg.sg_id
}


# variables
variable "sg" {}


# outputs
output "bastion_sg_id" {
  description = "The ID of the bastion security group"
  value       = module.bastion_sg.sg_id
}
# output "vpn_sg_id" {
#   description = "The ID of the VPN security group"
#   value       = module.vpn_sg.sg_id
# }
output "rds_sg_id" {
  description = "The ID of the RDS security group"
  value       = module.rds_sg.sg_id
}
output "elastic_cache_sg_id" {
  description = "The ID of the Elastic security group"
  value       = module.elastic_cache_sg.sg_id
}
output "backend_sg_id" {
  description = "The ID of the backend security group"
  value       = module.backend_sg.sg_id
}
output "internal_alb_sg_id" {
  description = "The ID of the internal ALB security group"
  value       = module.internal_alb_sg.sg_id
}
output "external_alb_sg_id" {
  description = "The ID of the external ALB security group"
  value       = module.external_alb_sg.sg_id
}
output "frontend_sg_id" {
  description = "The ID of the frontend security group"
  value       = module.frontend_sg.sg_id
}
