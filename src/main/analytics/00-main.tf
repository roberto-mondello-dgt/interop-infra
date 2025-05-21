terraform {
  required_version = "~> 1.8.0"

  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.46.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.tags
  }
}

provider "aws" {
  region = "eu-central-1"
  alias  = "ec1"

  default_tags {
    tags = var.tags
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.core.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.core.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.core.token
}

data "aws_caller_identity" "current" {}

data "aws_iam_role" "github_iac" {
  name = "GitHubActionIACRole"
}

data "aws_iam_role" "sso_admin" {
  name = var.sso_admin_role_name
}

locals {
  project                            = "interop"
  deploy_redshift_cluster            = var.env == "dev" || var.env == "prod"
  deploy_data_ingestion_resources    = var.env == "dev" || var.env == "test" || var.env == "prod"
  deploy_application_audit_resources = var.env == "qa"
  terraform_state                    = "analytics"
}
