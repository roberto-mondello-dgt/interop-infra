terraform {
  required_version = "~> 1.8.0"

  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.33.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.18.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.9.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = var.tags
  }
}

data "aws_eks_cluster" "this" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = var.eks_cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

data "aws_caller_identity" "current" {}

locals {
  deploy_be_refactor_infra  = true
  deploy_interop_api_v2     = var.env == "dev" || var.env == "test"
  deployment_repo_v2_active = var.env == "dev" || var.env == "qa" || var.env == "vapt" || var.env == "test"
  deploy_keda               = var.env == "dev" && var.keda_chart_version != null
  deploy_cluster_autoscaler = var.env == "dev" && var.cluster_autoscaler_chart_version != null
}
