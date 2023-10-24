locals {
  be_refactor_ns = "dev-refactor"
}

module "be_refactor_catalog_process_irsa" {
  count = var.env == "dev" ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.18.0"

  role_name = format("interop-be-catalog-process-refactor-%s", var.env)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.be_refactor_ns}:interop-be-catalog-process-refactor"]
    }
  }

  role_policy_arns = {
    be_refactor_catalog_process = aws_iam_policy.be_refactor_catalog_process[0].arn
  }
}

module "be_refactor_catalog_consumer_irsa" {
  count = var.env == "dev" ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.18.0"

  role_name = format("interop-be-catalog-consumer-refactor-%s", var.env)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.be_refactor_ns}:interop-be-catalog-consumer-refactor"]
    }
  }

  role_policy_arns = {
    be_refactor_catalog_topic_consumer = aws_iam_policy.be_refactor_catalog_topic_consumer[0].arn
  }
}
