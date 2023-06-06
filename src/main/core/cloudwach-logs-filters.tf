resource "aws_cloudwatch_log_metric_filter" "eks_app_logs_errors" {
  name           = format("eks-application-logs-errors-%s", var.env)
  pattern        = "{ $.log = \"*ERROR*\" || $.stream = \"stderr\" }"
  log_group_name = var.eks_application_log_group_name

  metric_transformation {
    name      = "ErrorCount"
    namespace = "EKSApplicationLogsFilters"
    value     = "1"

    dimensions = {
      PodApp = "$.pod_app"
    }
  }
}
