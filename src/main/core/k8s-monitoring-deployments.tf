# TODO: make alarms more configurable?
module "k8s_deployment_monitoring" {
  for_each = toset(concat(var.k8s_monitoring_deployments_names, var.k8s_monitoring_internal_deployments_names))

  source = "./modules/k8s-deployment-monitoring"

  env                 = var.env
  eks_cluster_name    = module.eks_v2.cluster_name
  k8s_namespace       = var.env
  k8s_deployment_name = each.key
  sns_topics_arns     = [aws_sns_topic.platform_alarms.arn]

  create_alarms = true

  avg_cpu_alarm_threshold           = 70
  avg_memory_alarm_threshold        = 70
  performance_alarms_period_seconds = 300 # 5 minutes

  create_dashboard = true

  cloudwatch_app_logs_errors_metric_name      = contains(var.k8s_monitoring_internal_deployments_names, each.key) ? aws_cloudwatch_log_metric_filter.eks_app_logs_errors.metric_transformation[0].name : null
  cloudwatch_app_logs_errors_metric_namespace = contains(var.k8s_monitoring_internal_deployments_names, each.key) ? aws_cloudwatch_log_metric_filter.eks_app_logs_errors.metric_transformation[0].namespace : null
}

module "be_refactor_k8s_deployment_monitoring" {
  for_each = toset([for d in concat(var.be_refactor_k8s_monitoring_deployments_names, var.be_refactor_k8s_monitoring_internal_deployments_names)
  : d if local.deploy_be_refactor_infra])

  source = "./modules/k8s-deployment-monitoring"

  env                 = var.env
  eks_cluster_name    = module.eks_v2.cluster_name
  k8s_namespace       = "dev-refactor"
  k8s_deployment_name = each.key
  sns_topics_arns     = [aws_sns_topic.be_refactor_platform_alarms[0].arn]

  create_alarms = true

  avg_cpu_alarm_threshold           = 70
  avg_memory_alarm_threshold        = 70
  performance_alarms_period_seconds = 300 # 5 minutes

  create_dashboard = true

  cloudwatch_app_logs_errors_metric_name      = contains(var.k8s_monitoring_internal_deployments_names, each.key) ? aws_cloudwatch_log_metric_filter.eks_app_logs_errors.metric_transformation[0].name : null
  cloudwatch_app_logs_errors_metric_namespace = contains(var.k8s_monitoring_internal_deployments_names, each.key) ? aws_cloudwatch_log_metric_filter.eks_app_logs_errors.metric_transformation[0].namespace : null
}



# TODO: refactor module to better support StatefulSets? the "unavailable-pods" alarm won't work
module "k8s_adot_monitoring" {
  source = "./modules/k8s-deployment-monitoring"

  env                 = var.env
  eks_cluster_name    = module.eks_v2.cluster_name
  k8s_namespace       = "aws-observability"
  k8s_deployment_name = "adot-collector"
  sns_topics_arns     = [aws_sns_topic.platform_alarms.arn]

  create_alarms = true

  avg_cpu_alarm_threshold           = 70
  avg_memory_alarm_threshold        = 70
  performance_alarms_period_seconds = 300 # 5 minutes

  create_dashboard = true
}

# TODO: remove once PoC is completed
module "k8s_auth_server_poc_monitoring" {
  count = var.env == "dev" ? 1 : 0

  source = "./modules/k8s-deployment-monitoring"

  env                 = var.env
  eks_cluster_name    = "interop-poc-token-eks-cluster-dev"
  k8s_namespace       = var.env
  k8s_deployment_name = "interop-be-authorization-server-poc-ts"

  create_alarms    = false
  create_dashboard = true
}
