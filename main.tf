# VPC
module "vpc" {
  source                     = "./modules/vpc"
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

# Bastion Host
module "bastion" {
  source = "./modules/ec2"

  environment  = var.common_vars["environment"]
  project_name = var.common_vars["application_name"]
  common_tags  = var.common_vars["common_tags"]

  ami             = data.aws_ami.amazon_linux.id
  security_groups = [module.bastion_sg.sg_id]
  subnet_id       = module.vpc.public_subnet_ids[0]
  private_key     = data.aws_ssm_parameter.ec2_key.value

  instance_name                  = var.bastion_ec2["instance_name"]
  instance_type                  = var.bastion_ec2["instance_type"]
  monitoring                     = var.bastion_ec2["monitoring"]
  use_null_resource_for_userdata = var.bastion_ec2["use_null_resource_for_userdata"]
  remote_exec_user               = var.bastion_ec2["remote_exec_user"]
  key_name                       = var.bastion_ec2["key_name"]
  user_data                      = var.bastion_ec2["user_data"]

  depends_on = [module.vpc, module.bastion_sg]

}

# VPN
module "vpn" {
  source = "./modules/ec2"

  environment  = var.common_vars["environment"]
  project_name = var.common_vars["application_name"]
  common_tags  = var.common_vars["common_tags"]

  ami             = data.aws_ami.openvpn.id
  security_groups = [module.vpn_sg.sg_id]
  subnet_id       = module.vpc.public_subnet_ids[1]

  instance_name                  = var.vpn_ec2["instance_name"]
  instance_type                  = var.vpn_ec2["instance_type"]
  monitoring                     = var.vpn_ec2["monitoring"]
  use_null_resource_for_userdata = var.vpn_ec2["use_null_resource_for_userdata"]
  key_name                       = var.bastion_ec2["key_name"]

  depends_on = [module.vpc, module.vpn_sg]

}

# RDS
module "rds" {
  depends_on             = [module.vpc, module.rds_sg]
  source                 = "./modules/rds"
  username               = data.aws_ssm_parameter.rds_username.value
  password               = data.aws_ssm_parameter.rds_password.value
  db_subnet_group_name   = module.vpc.db_subnet_group_name
  vpc_security_group_ids = [module.rds_sg.sg_id]
  environment            = var.common_vars["environment"]
  project                = var.common_vars["application_name"]
  common_tags            = var.common_vars["common_tags"]
  zone_id                = var.common_vars["zone_id"]
  allocated_storage      = var.rds["allocated_storage"]
  engine                 = var.rds["engine"]
  engine_version         = var.rds["engine_version"]
  instance_class         = var.rds["instance_class"]
  publicly_accessible    = var.rds["publicly_accessible"]
  skip_final_snapshot    = var.rds["skip_final_snapshot"]
  storage_type           = var.rds["storage_type"]
  rds_record_name        = var.rds["rds_record_name"]
  record_type            = var.rds["record_type"]
  ttl                    = var.rds["ttl"]
}

module "elasticache" {
  source                  = "./modules/elastic_cache"
  environment             = var.common_vars["environment"]
  project_name            = var.common_vars["application_name"]
  common_tags             = var.common_vars["common_tags"]
  zone_id                 = var.common_vars["zone_id"]
  security_group_ids      = [module.elastic_cache_sg.sg_id]
  subnet_ids              = module.vpc.db_subnet_ids
  engine                  = var.elasticache["engine"]
  major_engine_version    = var.elasticache["major_engine_version"]
  elasticache_record_name = var.elasticache["elasticache_record_name"]
  record_type             = var.elasticache["record_type"]
  ttl                     = var.elasticache["ttl"]
  depends_on              = [module.vpc, module.elastic_cache_sg]
}

module "internal-alb" {
  source                     = "./modules/elb"
  environment                = var.common_vars["environment"]
  project                    = var.common_vars["application_name"]
  common_tags                = var.common_vars["common_tags"]
  security_groups            = [module.internal_alb_sg.sg_id]
  subnets                    = module.vpc.private_subnet_ids
  vpc_id                     = module.vpc.vpc_id
  lb_name                    = var.internal_alb["lb_name"]
  enable_deletion_protection = var.internal_alb["enable_deletion_protection"]
  choose_internal_external   = var.internal_alb["choose_internal_external"]
  load_balancer_type         = var.internal_alb["load_balancer_type"]
  enable_zonal_shift         = var.internal_alb["enable_zonal_shift"]
  tg_port                    = var.internal_alb["tg_port"]
  health_check_path          = var.internal_alb["health_check_path"]
  enable_http                = var.internal_alb["enable_http"]
  enable_https               = var.internal_alb["enable_https"]
  zone_id                    = var.common_vars["zone_id"]
  record_name                = var.internal_alb["record_name"]
}

module "lb_acm" {
  source = "./modules/acm"
  environment        = var.common_vars["environment"]
  project_name       = var.common_vars["application_name"]
  common_tags        = var.common_vars["common_tags"]
  domain_name        = var.lb_acm["domain_name"]
  validation_method  = var.lb_acm["validation_method"]
  zone_id            = var.common_vars["zone_id"]
}

module "external-alb" {
  depends_on = [ module.lb_acm ]
  source                     = "./modules/elb"
  environment                = var.common_vars["environment"]
  project                    = var.common_vars["application_name"]
  common_tags                = var.common_vars["common_tags"]
  security_groups            = [module.external_alb_sg.sg_id]
  subnets                    = module.vpc.public_subnet_ids
  vpc_id                     = module.vpc.vpc_id
  lb_name                    = var.external_alb["lb_name"]
  enable_deletion_protection = var.external_alb["enable_deletion_protection"]
  choose_internal_external   = var.external_alb["choose_internal_external"]
  load_balancer_type         = var.external_alb["load_balancer_type"]
  enable_zonal_shift         = var.external_alb["enable_zonal_shift"]
  tg_port                    = var.external_alb["tg_port"]
  health_check_path          = var.external_alb["health_check_path"]
  enable_http                = var.external_alb["enable_http"]
  enable_https               = var.external_alb["enable_https"]
  certificate_arn            = module.lb_acm.certificate_arn
  zone_id                    = var.common_vars["zone_id"]
  record_name                = var.external_alb["record_name"]
}

module "backend_role"{
  source = "./modules/iam"
  environment = var.common_vars["environment"]
  project_name = var.common_vars["application_name"]
  common_tags = var.common_vars["common_tags"]
  role_name = var.backend_role["role_name"]
  policy_name = var.backend_role["policy_name"]
  policy_file = "${path.module}/environments/${var.common_vars["environment"]}/policies/backend-policy.json"
}
module "backend_role"{
  source = "./modules/iam"
  environment = var.common_vars["environment"]
  project_name = var.common_vars["application_name"]
  common_tags = var.common_vars["common_tags"]
  role_name = var.backend_role["role_name"]
  policy_name = var.backend_role["policy_name"]
  policy_file = "${path.module}/environments/${var.common_vars["environment"]}/policies/frontend-policy.json"
}



# module "backend_asg" {
#   depends_on = [ module.internal-alb,module.backend_sg ]
#   source = "./modules/asg"
#   environment                = var.common_vars["environment"]
#   project_name               = var.common_vars["application_name"]
#   common_tags                = var.common_vars["common_tags"]
#   instance_name              = var.backend_asg["instance_name"]
# }