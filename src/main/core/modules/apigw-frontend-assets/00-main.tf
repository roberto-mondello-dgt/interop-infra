terraform {
  required_version = "~> 1.3.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0.0"
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}