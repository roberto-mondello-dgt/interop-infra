terraform {
  required_version = "~> 1.3.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.65"
    }
  }
}

data "aws_caller_identity" "current" {}
