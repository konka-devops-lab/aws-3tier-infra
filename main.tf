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


module "bastion" {
  source = "./modules/ec2"

  environment               = var.common_vars["environment"]
  project_name              = var.common_vars["application_name"]
  common_tags               = var.common_vars["common_tags"]
  
  ami = data.aws_ami.amazon_linux.id
  security_groups = module.bastion_sg.sg_id
  subnet_id = module.vpc.public_subnet_ids[0]
  private_key = data.aws_ssm_parameter.ec2_key.value
  
  instance_name =var.bastion_ec2["instance_name"]
  instance_type = var.bastion_ec2["instance_type"]
  monitoring = var.bastion_ec2["monitoring"]
  use_null_resource_for_userdata = var.bastion_ec2["use_null_resource_for_userdata"]
  remote_exec_user = var.bastion_ec2["remote_exec_user"]
  key_name = var.bastion_ec2["key_name"]
  iam_instance_profile = var.bastion_ec2["iam_instance_profile"]
  user_data = var.bastion_ec2["user_data"]

}
