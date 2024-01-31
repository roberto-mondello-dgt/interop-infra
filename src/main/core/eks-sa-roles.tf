# TODO: rename roles after migration
locals {
  role_prefix = format("interop-iam-service-%s", var.env)

  # workaround to allow both 'dev' and 'dev-refactor'
  k8s_namespace_irsa = local.deploy_be_refactor_infra ? "dev*" : var.env
}

module "be_agreement_management_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  role_name = format("%s-interop-be-agreement-management", local.role_prefix)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-agreement-management"]
    }
  }

  role_policy_arns = {
    be_agreement_management = aws_iam_policy.be_agreement_management.arn
  }
}

module "be_authorization_management_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  role_name = format("%s-interop-be-authorization-management", local.role_prefix)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-authorization-management"]
    }
  }

  role_policy_arns = {
    be_authorization_management = aws_iam_policy.be_authorization_management.arn
  }
}

module "be_agreement_process_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  role_name = format("%s-interop-be-agreement-process", local.role_prefix)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-agreement-process"]
    }
  }

  role_policy_arns = {
    be_agreement_process = aws_iam_policy.be_agreement_process.arn
  }
}

module "be_catalog_management_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  role_name = format("%s-interop-be-catalog-management", local.role_prefix)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-catalog-management"]
    }
  }

  role_policy_arns = {
    be_catalog_management = aws_iam_policy.be_catalog_management.arn
  }
}

module "be_authorization_server_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  role_name = format("%s-interop-be-authorization-server", local.role_prefix)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-authorization-server"]
    }
  }

  role_policy_arns = {
    be_authorization_server = aws_iam_policy.be_authorization_server.arn
  }
}

module "be_catalog_process_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  role_name = format("%s-interop-be-catalog-process", local.role_prefix)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-catalog-process"]
    }
  }

  role_policy_arns = {
    be_catalog_proces = aws_iam_policy.be_catalog_process.arn
  }
}

module "be_purpose_management_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  role_name = format("%s-interop-be-purpose-management", local.role_prefix)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-purpose-management"]
    }
  }

  role_policy_arns = {
    be_purpose_management = aws_iam_policy.be_purpose_management.arn
  }
}

module "be_notifier_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  role_name = format("%s-interop-be-notifier", local.role_prefix)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-notifier"]
    }
  }

  role_policy_arns = {
    be_notifier = aws_iam_policy.be_notifier.arn
  }
}

module "be_purpose_process_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  role_name = format("%s-interop-be-purpose-process", local.role_prefix)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-purpose-process"]
    }
  }

  role_policy_arns = {
    be_purpose_process = aws_iam_policy.be_purpose_process.arn
  }
}

module "be_backend_for_frontend_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  role_name = format("%s-interop-be-backend-for-frontend", local.role_prefix)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-backend-for-frontend"]
    }
  }

  role_policy_arns = {
    be_backend_for_frontend = aws_iam_policy.be_backend_for_frontend.arn
  }
}

module "be_selfcare_onboarding_consumer_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  role_name = format("interop-be-selfcare-onboarding-consumer-%s", var.env)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-selfcare-onboarding-consumer"]
    }
  }

  role_policy_arns = {
    be_selfcare_onboarding_consumer = aws_iam_policy.be_selfcare_onboarding_consumer.arn
  }
}

module "be_anac_certified_attributes_importer_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  role_name = format("interop-be-anac-certified-attributes-importer-%s", var.env)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-anac-certified-attributes-importer"]
    }
  }

  role_policy_arns = {
    be_anac_certified_attributes_importer = aws_iam_policy.be_anac_certified_attributes_importer.arn
  }
}

module "be_ivass_certified_attributes_importer_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.18.0"

  role_name = format("interop-be-ivass-certified-attributes-importer-%s", var.env)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-ivass-certified-attributes-importer"]
    }
  }

  role_policy_arns = {
    be_ivass_certified_attributes_importer = aws_iam_policy.be_ivass_certified_attributes_importer.arn
  }
}

module "be_attributes_loader_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  role_name = format("%s-interop-be-attributes-loader", local.role_prefix)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-attributes-loader"]
    }
  }

  role_policy_arns = {
    be_attributes_loader = aws_iam_policy.be_attributes_loader.arn
  }
}

module "be_token_details_persister_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  role_name = format("%s-interop-be-token-details-persister", local.role_prefix)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-token-details-persister"]
    }
  }

  role_policy_arns = {
    be_token_details_persister = aws_iam_policy.be_token_details_persister.arn
  }
}

module "be_eservices_monitoring_exporter_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  role_name = format("interop-be-eservices-monitoring-exporter-%s", var.env)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-eservices-monitoring-exporter"]
    }
  }

  role_policy_arns = {
    be_eservices_monitoring_exporter = aws_iam_policy.be_eservices_monitoring_exporter.arn
  }
}

module "be_tenants_certified_attributes_updater_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  role_name = format("%s-interop-be-tenants-cert-attr-updater", local.role_prefix)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-tenants-cert-attr-updater"]
    }
  }

  role_policy_arns = {
    be_tenants_certified_attributes_updater = aws_iam_policy.be_tenants_certified_attributes_updater.arn
  }
}

module "be_certified_mail_sender_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  role_name = format("%s-interop-be-certified-mail-sender", local.role_prefix)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-certified-mail-sender"]
    }
  }

  role_policy_arns = {
    be_certified_mail_sender = aws_iam_policy.be_certified_mail_sender.arn
  }
}

module "be_party_registry_refresher_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  role_name = format("%s-interop-be-party-registry-refresher", local.role_prefix)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-party-registry-refresher"]
    }
  }
}

module "be_metrics_report_generator_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  role_name = format("interop-be-metrics-report-generator-%s", var.env)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-metrics-report-generator"]
    }
  }

  role_policy_arns = {
    be_metrics_report_generator = aws_iam_policy.be_metrics_report_generator.arn
  }
}

module "be_pa_digitale_report_generator_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  role_name = format("interop-be-padigitale-report-generator-%s", var.env)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-padigitale-report-generator"]
    }
  }

  role_policy_arns = {
    be_pa_digitale_report_generator = aws_iam_policy.be_pa_digitale_report_generator.arn
  }
}

module "be_dashboard_metrics_report_generator_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  role_name = format("interop-be-dashboard-metrics-report-generator-%s", var.env)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-dashboard-metrics-report-generator"]
    }
  }

  role_policy_arns = {
    be_dashboard_metrics_report_generator = aws_iam_policy.be_dashboard_metrics_report_generator.arn
  }
}

module "be_dtd_catalog_exporter_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  role_name = format("interop-be-dtd-catalog-exporter-%s", var.env)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-dtd-catalog-exporter"]
    }
  }

  role_policy_arns = {
    be_dtd_catalog_exporter = aws_iam_policy.be_dtd_catalog_exporter.arn
  }
}

module "be_privacy_notices_updater_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  role_name = format("interop-be-privacy-notices-updater-%s", var.env)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-privacy-notices-updater"]
    }
  }

  role_policy_arns = {
    be_privacy_notices_updater = aws_iam_policy.be_privacy_notices_updater.arn
  }
}

module "be_one_trust_notices_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  role_name = format("interop-be-one-trust-notices-%s", var.env)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-one-trust-notices"]
    }
  }

  role_policy_arns = {
    be_one_trust_notices = aws_iam_policy.be_one_trust_notices.arn
  }
}

module "be_purposes_archiver_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  role_name = format("interop-be-purposes-archiver-%s", var.env)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-purposes-archiver"]
    }
  }

  role_policy_arns = {
    be_purposes_archiver = aws_iam_policy.be_purposes_archiver.arn
  }
}

module "be_eservice_descriptors_archiver_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  role_name = format("interop-be-eservice-descriptors-archiver-%s", var.env)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-eservice-descriptors-archiver"]
    }
  }

  role_policy_arns = {
    be_eservice_descriptors_archiver = aws_iam_policy.be_eservice_descriptors_archiver.arn
  }
}

module "be_dtd_metrics_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.20.0"

  role_name = format("interop-be-dtd-metrics-%s", var.env)

  oidc_providers = {
    cluster = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["${local.k8s_namespace_irsa}:interop-be-dtd-metrics"]
    }
  }

  role_policy_arns = {
    be_dtd_metrics = aws_iam_policy.be_dtd_metrics.arn
  }
}

module "aws_load_balancer_controller_irsa" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = format("aws-load-balancer-controller-%s", var.env)

  oidc_providers = {
    main = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }

  role_description = "Role for AWS Load Balancer Controller"

  role_policy_arns = {
    aws_lb = aws_iam_policy.aws_load_balancer_controller.arn
  }
}

module "adot_iam_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.11.1"

  role_name = format("adot-collector-%s", var.env)

  oidc_providers = {
    eks = {
      provider_arn               = module.eks_v2.oidc_provider_arn
      namespace_service_accounts = ["aws-observability:adot-collector"]
    }
  }

  role_policy_arns = {
    cloudwatch = data.aws_iam_policy.cloudwatch_agent_server.arn
  }
}
