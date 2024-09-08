module "be_refactor_debezium_postgresql_irsa" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.18.0"

  role_name = format("interop-debezium-postgresql-%s", var.env)

  assume_role_condition_test = var.env == "dev" ? "StringLike" : "StringEquals"

  max_session_duration = 43200

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:debezium-postgresql"]
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

  role_name = format("interop-be-catalog-process-%s", var.env)

  assume_role_condition_test = var.env == "dev" ? "StringLike" : "StringEquals"

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = var.env == "dev" ? ["${local.k8s_namespace_irsa}:interop-be-catalog-process*"] : ["${local.k8s_namespace_irsa}:interop-be-catalog-process"]
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

  assume_role_condition_test = var.env == "dev" ? "StringLike" : "StringEquals"

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-catalog-readmodel-writer"]
    }
  }

  role_policy_arns = {
    be_refactor_catalog_readmodel_writer = aws_iam_policy.be_refactor_catalog_readmodel_writer[0].arn
  }
}

module "be_refactor_attribute_registry_readmodel_writer_irsa" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.18.0"

  role_name = format("interop-be-attribute-registry-readmodel-writer-%s", var.env)

  assume_role_condition_test = var.env == "dev" ? "StringLike" : "StringEquals"

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-attribute-registry-readmodel-writer"]
    }
  }

  role_policy_arns = {
    be_refactor_attribute_registry_readmodel_writer = aws_iam_policy.be_refactor_attribute_registry_readmodel_writer[0].arn
  }
}

module "be_refactor_agreement_email_sender_irsa" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.18.0"

  role_name = format("interop-be-agreement-email-sender-%s", var.env)

  assume_role_condition_test = var.env == "dev" ? "StringLike" : "StringEquals"

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-agreement-email-sender"]
    }
  }

  role_policy_arns = {
    be_refactor_agreement_email_sender = aws_iam_policy.be_refactor_agreement_email_sender[0].arn
  }
}

module "be_refactor_agreement_process_irsa" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.18.0"

  role_name = format("interop-be-agreement-process-%s", var.env)

  assume_role_condition_test = var.env == "dev" ? "StringLike" : "StringEquals"

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = var.env == "dev" ? ["${local.k8s_namespace_irsa}:interop-be-agreement-process*"] : ["${local.k8s_namespace_irsa}:interop-be-agreement-process"]
    }
  }

  role_policy_arns = {
    be_refactor_agreement_process = aws_iam_policy.be_refactor_agreement_process[0].arn
  }
}

module "be_refactor_agreement_readmodel_writer_irsa" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.18.0"

  role_name = format("interop-be-agreement-readmodel-writer-%s", var.env)

  assume_role_condition_test = var.env == "dev" ? "StringLike" : "StringEquals"

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-agreement-readmodel-writer"]
    }
  }

  role_policy_arns = {
    be_refactor_agreement_readmodel_writer = aws_iam_policy.be_refactor_agreement_readmodel_writer[0].arn
  }
}

module "be_refactor_purpose_process_irsa" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.18.0"

  role_name = format("interop-be-purpose-process-%s", var.env)

  assume_role_condition_test = var.env == "dev" ? "StringLike" : "StringEquals"

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = var.env == "dev" ? ["${local.k8s_namespace_irsa}:interop-be-purpose-process*"] : ["${local.k8s_namespace_irsa}:interop-be-purpose-process"]
    }
  }

  role_policy_arns = {
    be_refactor_purpose_process = aws_iam_policy.be_refactor_purpose_process[0].arn
  }
}

module "be_refactor_purpose_readmodel_writer_irsa" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.18.0"

  role_name = format("interop-be-purpose-readmodel-writer-%s", var.env)

  assume_role_condition_test = var.env == "dev" ? "StringLike" : "StringEquals"

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-purpose-readmodel-writer"]
    }
  }

  role_policy_arns = {
    be_refactor_purpose_readmodel_writer = aws_iam_policy.be_refactor_purpose_readmodel_writer[0].arn
  }
}

module "be_refactor_client_readmodel_writer_irsa" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.18.0"

  role_name = format("interop-be-client-readmodel-writer-%s", var.env)

  assume_role_condition_test = var.env == "dev" ? "StringLike" : "StringEquals"

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-client-readmodel-writer"]
    }
  }

  role_policy_arns = {
    be_refactor_client_readmodel_writer = aws_iam_policy.be_refactor_client_readmodel_writer[0].arn
  }
}

module "be_refactor_key_readmodel_writer_irsa" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.18.0"

  role_name = format("interop-be-key-readmodel-writer-%s", var.env)

  assume_role_condition_test = var.env == "dev" ? "StringLike" : "StringEquals"

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-key-readmodel-writer"]
    }
  }

  role_policy_arns = {
    be_refactor_key_readmodel_writer = aws_iam_policy.be_refactor_key_readmodel_writer[0].arn
  }
}

module "be_refactor_tenant_readmodel_writer_irsa" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.18.0"

  role_name = format("interop-be-tenant-readmodel-writer-%s", var.env)

  assume_role_condition_test = var.env == "dev" ? "StringLike" : "StringEquals"

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-tenant-readmodel-writer"]
    }
  }

  role_policy_arns = {
    be_refactor_tenant_readmodel_writer = aws_iam_policy.be_refactor_tenant_readmodel_writer[0].arn
  }
}

module "be_refactor_compute_agreements_consumer_irsa" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.18.0"

  role_name = format("interop-be-compute-agreements-consumer-%s", var.env)

  assume_role_condition_test = var.env == "dev" ? "StringLike" : "StringEquals"

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-compute-agreements-consumer"]
    }
  }

  role_policy_arns = {
    be_refactor_compute_agreements_consumer = aws_iam_policy.be_refactor_compute_agreements_consumer[0].arn
  }
}

module "be_refactor_authorization_updater_irsa" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.18.0"

  role_name = format("interop-be-authorization-updater-%s", var.env)

  assume_role_condition_test = var.env == "dev" ? "StringLike" : "StringEquals"

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-authorization-updater"]
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

  assume_role_condition_test = var.env == "dev" ? "StringLike" : "StringEquals"

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-notifier-seeder"]
    }
  }

  role_policy_arns = {
    be_refactor_notifier_seeder = aws_iam_policy.be_refactor_notifier_seeder[0].arn
  }
}
