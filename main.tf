# VPC
module "vpc" {
  source                    = "./modules/vpc"
  environment               = var.common_vars["environment"]
  application_name          = var.common_vars["application_name"]
  common_tags               = var.common_vars["common_tags"]
  vpc_cidr_block            = var.vpc["vpc_cidr_block"]
  availability_zone         = var.vpc["availability_zone"]
  public_subnet_cidr_blocks = var.vpc["public_subnet_cidr_blocks"]
  private_subnet_cidr_blocks = var.vpc["private_subnet_cidr_blocks"]
  db_subnet_cidr_blocks     = var.vpc["db_subnet_cidr_blocks"]
  enable_nat_gateway        = var.vpc["enable_nat_gateway"]
  enable_vpc_flow_logs_cw   = var.vpc["enable_vpc_flow_logs_cw"]
}

# Bastion Host
module "bastion" {
  source = "./modules/ec2"

  environment               = var.common_vars["environment"]
  project_name              = var.common_vars["application_name"]
  common_tags               = var.common_vars["common_tags"]
  
  ami = data.aws_ami.amazon_linux.id
  security_groups = [module.bastion_sg.sg_id]
  subnet_id = module.vpc.public_subnet_ids[0]
  private_key = data.aws_ssm_parameter.ec2_key.value
  
  instance_name =var.bastion_ec2["instance_name"]
  instance_type = var.bastion_ec2["instance_type"]
  monitoring = var.bastion_ec2["monitoring"]
  use_null_resource_for_userdata = var.bastion_ec2["use_null_resource_for_userdata"]
  remote_exec_user = var.bastion_ec2["remote_exec_user"]
  key_name = var.bastion_ec2["key_name"]
  user_data = var.bastion_ec2["user_data"]

  depends_on = [ module.vpc, module.bastion_sg ]

}

# VPN
module "vpn" {
  source = "./modules/ec2"

  environment               = var.common_vars["environment"]
  project_name              = var.common_vars["application_name"]
  common_tags               = var.common_vars["common_tags"]
  
  ami = data.aws_ami.openvpn.id
  security_groups = [module.vpn_sg.sg_id]
  subnet_id = module.vpc.public_subnet_ids[1]
  
  instance_name =var.vpn_ec2["instance_name"]
  instance_type = var.vpn_ec2["instance_type"]
  monitoring = var.vpn_ec2["monitoring"]
  use_null_resource_for_userdata = var.vpn_ec2["use_null_resource_for_userdata"]
  key_name = var.bastion_ec2["key_name"]

  depends_on = [ module.vpc, module.vpn_sg ]

}

# RDS
module "rds" {
  depends_on             = [module.vpc, module.rds_sg]
  source                 = "../terraform-modules/rds"
  username               = data.aws_ssm_parameter.rds_username.value
  password               = data.aws_ssm_parameter.rds_password.value
  db_subnet_group_name   = module.vpc.db_subnet_group_name
  vpc_security_group_ids = [module.rds_sg.sg_id]
  environment            = var.common_vars["environment"]
  project                = var.common_vars["application_name"]
  common_tags            = var.common_vars["common_tags"]
  allocated_storage      = var.rds["allocated_storage"]
  engine                 = var.rds["engine"]
  engine_version         = var.rds["engine_version"]
  instance_class         = var.rds["instance_class"]
  publicly_accessible    = var.rds["publicly_accessible"]
  skip_final_snapshot    = var.rds["skip_final_snapshot"]
  identifier             = var.rds["identifier"]
  storage_type           = var.rds["storage_type"]
  zone_id                = var.rds["zone_id"]
  rds_record_name        = var.rds["rds_record_name"]
  record_type            = var.rds["record_type"]
  ttl                    = var.rds["ttl"]
}
