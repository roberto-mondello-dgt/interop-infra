terraform {
  required_version = "~> 1.8.0"

  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.46.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.tags
  }

  # avoid drift between VPC module and K8s tags applied only for some specific subnets
  ignore_tags {
    keys = ["kubernetes.io/role/elb", "kubernetes.io/role/internal-elb"]
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "us_east_1"

  default_tags {
    tags = var.tags
  }
}

data "aws_caller_identity" "current" {}

data "aws_iam_role" "github_iac" {
  name = "GitHubActionIACRole"
}

data "aws_iam_role" "sso_admin" {
  name = var.sso_admin_role_name
}

locals {
  project                     = "interop"
  deploy_be_refactor_infra    = var.env == "dev" || var.env == "qa" || var.env == "test" || var.env == "att" || var.env == "prod"
  deploy_new_bff_apigw        = var.env == "dev" || var.env == "qa" || var.env == "test" || var.env == "att" || var.env == "prod"
  deploy_safe_storage_infra   = var.safe_storage_account_id != null && var.safe_storage_vpce_service_name != null
  deploy_auth_server_refactor = local.deploy_be_refactor_infra && var.env == "dev"
  on_call_env                 = var.env == "dev" || var.env == "prod" # DEV is used for testing
}
