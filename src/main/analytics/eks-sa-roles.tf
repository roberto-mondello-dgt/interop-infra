data "aws_eks_cluster" "core" {
  name = var.eks_cluster_name
}

data "aws_iam_openid_connect_provider" "core_eks" {
  url = data.aws_eks_cluster.core.identity[0].oidc[0].issuer
}

locals {
  # workaround to allow both 'dev' and 'dev-refactor'
  k8s_namespace_irsa = var.env == "dev" ? "dev*" : var.env
}

module "be_analytics_domain_consumer_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  role_name = format("interop-be-analytics-domain-consumer-%s-es1", var.env)

  assume_role_condition_test = var.env == "dev" ? "StringLike" : "StringEquals"

  oidc_providers = {
    cluster = {
      provider_arn               = data.aws_iam_openid_connect_provider.core_eks.arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-analytics-domain-consumer"]
    }
  }
}

module "be_analytics_jwt_consumer_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  role_name = format("interop-be-analytics-jwt-consumer-%s-es1", var.env)

  assume_role_condition_test = var.env == "dev" ? "StringLike" : "StringEquals"

  oidc_providers = {
    cluster = {
      provider_arn               = data.aws_iam_openid_connect_provider.core_eks.arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-analytics-jwt-consumer"]
    }
  }
}
