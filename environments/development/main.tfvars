aws_region = "ap-south-1"
common_vars = {
  environment      = "development"
  application_name = "tf-aws-3-tier-infra"
  common_tags = {
    Project     = "tf-aws-3-tier-infra"
    Environment = "development"
    terraform   = "true"
    Owner       = "konka"
  }
}
vpc = {
  vpc_cidr_block            = "10.1.0.0/16"
  availability_zone         = ["ap-south-1a", "ap-south-1b"]
  public_subnet_cidr_blocks = ["10.1.1.0/24", "10.1.2.0/24"]
}