# TODO: use foreach?

module "be_agreement_management_monitoring" {
  source = "./modules/k8s-deployment-monitoring"

  env                 = var.env
  eks_cluster_name    = module.eks_v2.cluster_name
  k8s_namespace       = var.env
  k8s_deployment_name = "interop-be-agreement-management"
  sns_topics_arns     = [aws_sns_topic.platform_alarms.arn]

  create_alarms = true

  avg_cpu_alarm_threshold    = 70
  avg_memory_alarm_threshold = 70
  alarm_period_seconds       = 900 # 15 minutes

  create_dashboard = true
}

module "be_agreement_process_monitoring" {
  source = "./modules/k8s-deployment-monitoring"

  env                 = var.env
  eks_cluster_name    = module.eks_v2.cluster_name
  k8s_namespace       = var.env
  k8s_deployment_name = "interop-be-agreement-management"
  sns_topics_arns     = [aws_sns_topic.platform_alarms.arn]

  create_alarms = true

  avg_cpu_alarm_threshold    = 70
  avg_memory_alarm_threshold = 70
  alarm_period_seconds       = 900 # 15 minutes

  create_dashboard = true
}

module "be_api_gateway_monitoring" {
  source = "./modules/k8s-deployment-monitoring"

  env                 = var.env
  eks_cluster_name    = module.eks_v2.cluster_name
  k8s_namespace       = var.env
  k8s_deployment_name = "interop-be-api-gateway"
  sns_topics_arns     = [aws_sns_topic.platform_alarms.arn]

  create_alarms = true

  avg_cpu_alarm_threshold    = 70
  avg_memory_alarm_threshold = 70
  alarm_period_seconds       = 900 # 15 minutes

  create_dashboard = true
}

module "be_attribute_registry_management_monitoring" {
  source = "./modules/k8s-deployment-monitoring"

  env                 = var.env
  eks_cluster_name    = module.eks_v2.cluster_name
  k8s_namespace       = var.env
  k8s_deployment_name = "interop-be-attribute-registry-management"
  sns_topics_arns     = [aws_sns_topic.platform_alarms.arn]

  create_alarms = true

  avg_cpu_alarm_threshold    = 70
  avg_memory_alarm_threshold = 70
  alarm_period_seconds       = 900 # 15 minutes

  create_dashboard = true
}

module "be_authorization_management_monitoring" {
  source = "./modules/k8s-deployment-monitoring"

  env                 = var.env
  eks_cluster_name    = module.eks_v2.cluster_name
  k8s_namespace       = var.env
  k8s_deployment_name = "interop-be-authorization-management"
  sns_topics_arns     = [aws_sns_topic.platform_alarms.arn]

  create_alarms = true

  avg_cpu_alarm_threshold    = 70
  avg_memory_alarm_threshold = 70
  alarm_period_seconds       = 900 # 15 minutes

  create_dashboard = true
}

module "be_authorization_process_monitoring" {
  source = "./modules/k8s-deployment-monitoring"

  env                 = var.env
  eks_cluster_name    = module.eks_v2.cluster_name
  k8s_namespace       = var.env
  k8s_deployment_name = "interop-be-authorization-process"
  sns_topics_arns     = [aws_sns_topic.platform_alarms.arn]

  create_alarms = true

  avg_cpu_alarm_threshold    = 70
  avg_memory_alarm_threshold = 70
  alarm_period_seconds       = 900 # 15 minutes

  create_dashboard = true
}

module "be_authorization_server_monitoring" {
  source = "./modules/k8s-deployment-monitoring"

  env                 = var.env
  eks_cluster_name    = module.eks_v2.cluster_name
  k8s_namespace       = var.env
  k8s_deployment_name = "interop-be-authorization-server"
  sns_topics_arns     = [aws_sns_topic.platform_alarms.arn]

  create_alarms = true

  avg_cpu_alarm_threshold    = 70
  avg_memory_alarm_threshold = 70
  alarm_period_seconds       = 900 # 15 minutes

  create_dashboard = true
}

module "be_backend_for_frontend_monitoring" {
  source = "./modules/k8s-deployment-monitoring"

  env                 = var.env
  eks_cluster_name    = module.eks_v2.cluster_name
  k8s_namespace       = var.env
  k8s_deployment_name = "interop-be-backend-for-frontend"
  sns_topics_arns     = [aws_sns_topic.platform_alarms.arn]

  create_alarms = true

  avg_cpu_alarm_threshold    = 70
  avg_memory_alarm_threshold = 70
  alarm_period_seconds       = 900 # 15 minutes

  create_dashboard = true
}

module "be_catalog_management_monitoring" {
  source = "./modules/k8s-deployment-monitoring"

  env                 = var.env
  eks_cluster_name    = module.eks_v2.cluster_name
  k8s_namespace       = var.env
  k8s_deployment_name = "interop-be-catalog-management"
  sns_topics_arns     = [aws_sns_topic.platform_alarms.arn]

  create_alarms = true

  avg_cpu_alarm_threshold    = 70
  avg_memory_alarm_threshold = 70
  alarm_period_seconds       = 900 # 15 minutes

  create_dashboard = true
}

module "be_catalog_process_monitoring" {
  source = "./modules/k8s-deployment-monitoring"

  env                 = var.env
  eks_cluster_name    = module.eks_v2.cluster_name
  k8s_namespace       = var.env
  k8s_deployment_name = "interop-be-catalog-process"
  sns_topics_arns     = [aws_sns_topic.platform_alarms.arn]

  create_alarms = true

  avg_cpu_alarm_threshold    = 70
  avg_memory_alarm_threshold = 70
  alarm_period_seconds       = 900 # 15 minutes

  create_dashboard = true
}

module "be_notifier_monitoring" {
  source = "./modules/k8s-deployment-monitoring"

  env                 = var.env
  eks_cluster_name    = module.eks_v2.cluster_name
  k8s_namespace       = var.env
  k8s_deployment_name = "interop-be-notifier"
  sns_topics_arns     = [aws_sns_topic.platform_alarms.arn]

  create_alarms = true

  avg_cpu_alarm_threshold    = 70
  avg_memory_alarm_threshold = 70
  alarm_period_seconds       = 900 # 15 minutes

  create_dashboard = true
}

module "be_party_registry_proxy_monitoring" {
  source = "./modules/k8s-deployment-monitoring"

  env                 = var.env
  eks_cluster_name    = module.eks_v2.cluster_name
  k8s_namespace       = var.env
  k8s_deployment_name = "interop-be-party-registry-proxy"
  sns_topics_arns     = [aws_sns_topic.platform_alarms.arn]

  create_alarms = true

  avg_cpu_alarm_threshold    = 70
  avg_memory_alarm_threshold = 70
  alarm_period_seconds       = 900 # 15 minutes

  create_dashboard = true
}

module "be_purpose_management_monitoring" {
  source = "./modules/k8s-deployment-monitoring"

  env                 = var.env
  eks_cluster_name    = module.eks_v2.cluster_name
  k8s_namespace       = var.env
  k8s_deployment_name = "interop-be-purpose-management"
  sns_topics_arns     = [aws_sns_topic.platform_alarms.arn]

  create_alarms = true

  avg_cpu_alarm_threshold    = 70
  avg_memory_alarm_threshold = 70
  alarm_period_seconds       = 900 # 15 minutes

  create_dashboard = true
}

module "be_purpose_process_monitoring" {
  source = "./modules/k8s-deployment-monitoring"

  env                 = var.env
  eks_cluster_name    = module.eks_v2.cluster_name
  k8s_namespace       = var.env
  k8s_deployment_name = "interop-be-purpose-process"
  sns_topics_arns     = [aws_sns_topic.platform_alarms.arn]

  create_alarms = true

  avg_cpu_alarm_threshold    = 70
  avg_memory_alarm_threshold = 70
  alarm_period_seconds       = 900 # 15 minutes

  create_dashboard = true
}

module "be_tenant_management_monitoring" {
  source = "./modules/k8s-deployment-monitoring"

  env                 = var.env
  eks_cluster_name    = module.eks_v2.cluster_name
  k8s_namespace       = var.env
  k8s_deployment_name = "interop-be-tenant-management"
  sns_topics_arns     = [aws_sns_topic.platform_alarms.arn]

  create_alarms = true

  avg_cpu_alarm_threshold    = 70
  avg_memory_alarm_threshold = 70
  alarm_period_seconds       = 900 # 15 minutes

  create_dashboard = true
}

module "be_tenant_process_monitoring" {
  source = "./modules/k8s-deployment-monitoring"

  env                 = var.env
  eks_cluster_name    = module.eks_v2.cluster_name
  k8s_namespace       = var.env
  k8s_deployment_name = "interop-be-tenant-process"
  sns_topics_arns     = [aws_sns_topic.platform_alarms.arn]

  create_alarms = true

  avg_cpu_alarm_threshold    = 70
  avg_memory_alarm_threshold = 70
  alarm_period_seconds       = 900 # 15 minutes

  create_dashboard = true
}

module "frontend_monitoring" {
  source = "./modules/k8s-deployment-monitoring"

  env                 = var.env
  eks_cluster_name    = module.eks_v2.cluster_name
  k8s_namespace       = var.env
  k8s_deployment_name = "interop-frontend"
  sns_topics_arns     = [aws_sns_topic.platform_alarms.arn]

  create_alarms = true

  avg_cpu_alarm_threshold    = 70
  avg_memory_alarm_threshold = 70
  alarm_period_seconds       = 900 # 15 minutes

  create_dashboard = true
}

module "be_redis_monitoring" {
  source = "./modules/k8s-deployment-monitoring"

  env                 = var.env
  eks_cluster_name    = module.eks_v2.cluster_name
  k8s_namespace       = var.env
  k8s_deployment_name = "redis"
  sns_topics_arns     = [aws_sns_topic.platform_alarms.arn]

  create_alarms = true

  avg_cpu_alarm_threshold    = 70
  avg_memory_alarm_threshold = 70
  alarm_period_seconds       = 900 # 15 minutes

  create_dashboard = true
}

