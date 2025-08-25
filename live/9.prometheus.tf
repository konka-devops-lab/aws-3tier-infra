module "prometheus" {
  source = "../modules/ec2"

  environment  = var.common_vars["environment"]
  project_name = var.common_vars["application_name"]
  common_tags  = var.common_vars["common_tags"]

  ami                            = data.aws_ami.amazon_linux.id
  security_groups                = [module.prometheus_sg.sg_id]
  subnet_id                      = module.vpc.public_subnet_ids[0]
  private_key                    = data.aws_ssm_parameter.ec2_key.value
  iam_instance_profile           = module.prometheus_role.instance_profile_id
  instance_name                  = var.prometheus_ec2["instance_name"]
  instance_type                  = var.prometheus_ec2["instance_type"]
  monitoring                     = var.prometheus_ec2["monitoring"]
  use_null_resource_for_userdata = var.prometheus_ec2["use_null_resource_for_userdata"]
  remote_exec_user               = var.prometheus_ec2["remote_exec_user"]
  key_name                       = var.prometheus_ec2["key_name"]
  user_data                      = file("${path.module}/../environments/${var.common_vars["environment"]}/scripts/prometheus.sh")
}
variable "prometheus_ec2" {}