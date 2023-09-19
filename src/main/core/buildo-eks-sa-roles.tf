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

module "be_refactor_event_consumer_irsa" {
  count = var.env == "dev" ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.18.0"

  role_name = format("interop-be-event-consumer-refactor-%s", var.env)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.be_refactor_ns}:interop-be-event-consumer-refactor"]
    }
  }

  role_policy_arns = {
    be_refactor_msk_catalog_public_topic_reader = aws_iam_policy.be_refactor_msk_catalog_public_topic_reader[0].arn
  }
}
