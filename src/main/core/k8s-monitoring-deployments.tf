# TODO: make alarms more configurable?
module "k8s_deployment_monitoring" {
  for_each = toset(var.k8s_monitoring_deployments_names)

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
}
