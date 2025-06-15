variable "aws_region" {
  description = "AWS region where the resources will be created"
  type        = string
}

variable "common_vars" {
  description = "Common variables for the infrastructure"
  type = object({
    environment      = string
    application_name = string
    common_tags      = map(string)
  })
}

variable "vpc" {
  description = "VPC configuration variables"
  type = object({
    vpc_cidr_block            = string
    public_subnet_cidr_blocks = list(string)
    private_subnet_cidr_blocks = list(string)
    db_subnet_cidr_blocks = list(string)
    availability_zone         = list(string)
    enable_nat_gateway        = bool
    enable_vpc_flow_logs_cw   = bool
  })
}

variable "sg" {}
variable "bastion_ec2" {
  description = "EC2 instance configuration variables"
  type = object({
    instance_name                   = string
    instance_type                   = string
    key_name                        = string
    monitoring                      = bool
    user_data                       = optional(string, null)
    use_null_resource_for_userdata  = bool
    remote_exec_user                = string
    iam_instance_profile            = optional(string, "")
  })
}