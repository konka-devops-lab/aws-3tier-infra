variable "aws_region" {
  description = "AWS region where the resources will be created"
  type        = string
}
variable "common_vars" {}
variable "vpc" {}
variable "sg" {}
variable "bastion_ec2" {}
variable "vpn_ec2" {}
variable "rds" {}
variable "elasticache" {}
variable "internal_alb"{}
variable "lb_acm" {}
variable "external_alb" {}