data "aws_ssm_parameter" "ec2_key" {
  name            = "/expense/ec2/siva"
  with_decryption = true
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}


module "bastion" {
  source = "../modules/ec2"

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
  user_data                      = file("${path.module}/../environments/${var.common_vars["environment"]}/scripts/bastion.sh")
}
variable "bastion_ec2" {}


# data "aws_ami" "openvpn" {
#   most_recent = true
#   owners      = ["679593333241"]

#   filter {
#     name   = "name"
#     values = ["OpenVPN Access Server Community Image-fe8020db-*"]
#   }

#   filter {
#     name   = "root-device-type"
#     values = ["ebs"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# }
# module "vpn" {
#   source = "../modules/ec2"

#   environment  = var.common_vars["environment"]
#   project_name = var.common_vars["application_name"]
#   common_tags  = var.common_vars["common_tags"]

#   ami             = data.aws_ami.openvpn.id
#   security_groups = [module.vpn_sg.sg_id]
#   subnet_id       = module.vpc.public_subnet_ids[1]

#   instance_name                  = var.vpn_ec2["instance_name"]
#   instance_type                  = var.vpn_ec2["instance_type"]
#   monitoring                     = var.vpn_ec2["monitoring"]
#   use_null_resource_for_userdata = var.vpn_ec2["use_null_resource_for_userdata"]
#   key_name                       = var.bastion_ec2["key_name"]

#   depends_on = [module.vpc, module.vpn_sg]
# }

# variable "vpn_ec2" {

# }