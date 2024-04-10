locals {
  be_refactor_ns     = var.env == "dev" ? "dev-refactor" : var.env
  be_refactor_suffix = var.env == "dev" ? "-refactor" : ""
}

module "be_refactor_debezium_postgresql_irsa" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.18.0"

  role_name = format("interop-debezium-postgresql-%s", var.env)

  max_session_duration = 43200

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.be_refactor_ns}:debezium-postgresql"]
    }
  }

  role_policy_arns = {
    be_refactor_debezium_postgresql = aws_iam_policy.be_refactor_debezium_postgresql[0].arn
  }
}

module "be_refactor_catalog_process_irsa" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.18.0"

  role_name = format("interop-be-catalog-process${local.be_refactor_suffix}-%s", var.env)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.be_refactor_ns}:interop-be-catalog-process${local.be_refactor_suffix}"]
    }
  }

  role_policy_arns = {
    be_refactor_catalog_process = aws_iam_policy.be_refactor_catalog_process[0].arn
  }
}

module "be_refactor_catalog_readmodel_writer_irsa" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.18.0"

  role_name = format("interop-be-catalog-readmodel-writer-%s", var.env)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.be_refactor_ns}:interop-be-catalog-readmodel-writer"]
    }
  }

  role_policy_arns = {
    be_refactor_catalog_readmodel_writer = aws_iam_policy.be_refactor_catalog_readmodel_writer[0].arn
  }
}

module "be_refactor_agreement_readmodel_writer_irsa" {
  count = var.env == "dev" ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.18.0"

  role_name = format("interop-be-agreement-readmodel-writer-%s", var.env)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.be_refactor_ns}:interop-be-agreement-readmodel-writer"]
    }
  }

  role_policy_arns = {
    be_refactor_agreement_readmodel_writer = aws_iam_policy.be_refactor_agreement_readmodel_writer[0].arn
  }
}

module "be_refactor_authorization_updater_irsa" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.18.0"

  role_name = format("interop-be-authorization-updater-%s", var.env)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.be_refactor_ns}:interop-be-authorization-updater"]
    }
  }

  role_policy_arns = {
    be_refactor_authorization_updater = aws_iam_policy.be_refactor_authorization_updater[0].arn
  }
}

module "be_refactor_notifier_seeder_irsa" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.18.0"

  role_name = format("interop-be-notifier-seeder-%s", var.env)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.be_refactor_ns}:interop-be-notifier-seeder"]
    }
  }

  role_policy_arns = {
    be_refactor_notifier_seeder = aws_iam_policy.be_refactor_notifier_seeder[0].arn
  }
}
