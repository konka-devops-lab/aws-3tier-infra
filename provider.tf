terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.100.0"
    }
  }
  backend "s3" {
    bucket         = var.s3_bucket_name
    key            = "terraform/state"
    region         = var.aws_region
    dynamodb_table = var.dynamodb_table_name
  }
}

provider "aws" {
  region = var.aws_region
}