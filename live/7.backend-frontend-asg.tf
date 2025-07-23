data "aws_ami" "backend_ami" {
  most_recent = true
  owners      = ["522814728660"]

  filter {
    name   = "name"
    values = ["sivab-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

data "aws_ami" "frontend_ami" {
  most_recent = true
  owners      = ["522814728660"]

  filter {
    name   = "name"
    values = ["sivaf-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

module "backend_asg" {
  depends_on = [module.rds]
  source     = "../modules/asg"

  environment  = var.common_vars["environment"]
  project_name = var.common_vars["application_name"]
  common_tags  = var.common_vars["common_tags"]

  key_name                 = var.bastion_ec2["key_name"]
  instance_type            = var.bastion_ec2["instance_type"]
  iam_instance_profile_arn = module.backend_role.instance_profile_arn
  image_id                 = data.aws_ami.backend_ami.id
  subnet_ids               = module.vpc.private_subnet_ids
  target_group_arns        = [module.internal-alb.target_group_arn]
  security_groups          = [module.backend_sg.sg_id]
  monitoring_enable        = var.backend_asg["monitoring_enable"]
  instance_name            = var.backend_asg["instance_name"]
  user_data                = file("${path.module}/../environments/${var.common_vars["environment"]}/scripts/backend.sh")
  max_size                 = var.backend_asg["max_size"]
  min_size                 = var.backend_asg["min_size"]
  desired_capacity         = var.backend_asg["desired_capacity"]
  target_value             = var.backend_asg["target_value"]
}

variable "backend_asg" {}


module "frontend_asg" {
  depends_on = [module.backend_asg]
  source     = "../modules/asg"

  environment  = var.common_vars["environment"]
  project_name = var.common_vars["application_name"]
  common_tags  = var.common_vars["common_tags"]

  key_name                 = var.bastion_ec2["key_name"]
  instance_type            = var.bastion_ec2["instance_type"]
  iam_instance_profile_arn = module.frontend_role.instance_profile_arn
  image_id                 = data.aws_ami.frontend_ami.id
  subnet_ids               = module.vpc.private_subnet_ids
  target_group_arns        = [module.external-alb.target_group_arn]
  security_groups          = [module.frontend_sg.sg_id]
  monitoring_enable        = var.frontend_asg["monitoring_enable"]
  instance_name            = var.frontend_asg["instance_name"]
  user_data                = file("${path.module}/../environments/${var.common_vars["environment"]}/scripts/frontend.sh")
  max_size                 = var.frontend_asg["max_size"]
  min_size                 = var.frontend_asg["min_size"]
  desired_capacity         = var.frontend_asg["desired_capacity"]
  target_value             = var.frontend_asg["target_value"]
}


variable "frontend_asg" {}
