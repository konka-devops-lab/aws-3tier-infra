terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.100.0"
    }
  }
  backend "s3" {}
}

provider "aws" {
  region = var.common_vars["region"]
}