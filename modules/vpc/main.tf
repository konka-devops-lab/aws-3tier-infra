locals {
  common_name = "${var.environment}-${var.application_name}"
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = merge(
    var.common_tags,
    {
      Name = "${local.common_name}-vpc"
    }

  )
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    {
      Name = "${local.common_name}-igw"
    }

  )
}

resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnet_cidr_blocks)
  vpc_id     = aws_vpc.main.id
  availability_zone  = var.availability_zone[count.index] 
  cidr_block = var.public_subnet_cidr_blocks[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    {
      Name = "${local.common_name}-public-subnet-${split("-",var.availability_zone[count.index])[2]}"
    }
  )
}


