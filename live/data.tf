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
data "aws_ssm_parameter" "rds_username" {
  name = "/example/rds/username"
}
data "aws_ssm_parameter" "rds_password" {
  name = "/example/rds/password"
}