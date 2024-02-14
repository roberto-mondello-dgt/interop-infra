resource "aws_cloudwatch_metric_alarm" "cronjob_errors" {
  for_each = toset(var.k8s_monitoring_cronjobs_names)

  alarm_name        = format("k8s-cronjob-%s-errors-%s", each.key, var.env)
  alarm_description = format("Cronjob errors alarm for %s", each.key)

  alarm_actions = [aws_sns_topic.platform_alarms.arn]

  metric_name = aws_cloudwatch_log_metric_filter.eks_app_logs_errors.metric_transformation[0].name
  namespace   = aws_cloudwatch_log_metric_filter.eks_app_logs_errors.metric_transformation[0].namespace

  dimensions = {
    PodApp       = each.key
    PodNamespace = var.env
  }

  comparison_operator = "GreaterThanOrEqualToThreshold"
  statistic           = "Sum"
  treat_missing_data  = "notBreaching"

  threshold           = 1
  period              = 60 # 1 minute
  evaluation_periods  = 5
  datapoints_to_alarm = 1
}

resource "aws_cloudwatch_metric_alarm" "be_refactor_cronjob_errors" {
  for_each = toset([for c in var.k8s_monitoring_cronjobs_names : c if local.deploy_be_refactor_infra])

  alarm_name        = format("k8s-cronjob-%s-errors-refactor-%s", each.key, var.env)
  alarm_description = format("Cronjob errors alarm for %s-refactor", each.key)

  alarm_actions = [aws_sns_topic.be_refactor_platform_alarms[0].arn]

  metric_name = aws_cloudwatch_log_metric_filter.eks_app_logs_errors.metric_transformation[0].name
  namespace   = aws_cloudwatch_log_metric_filter.eks_app_logs_errors.metric_transformation[0].namespace

  dimensions = {
    PodApp       = each.key
    PodNamespace = "dev-refactor"
  }

  comparison_operator = "GreaterThanOrEqualToThreshold"
  statistic           = "Sum"
  treat_missing_data  = "notBreaching"

  threshold           = 1
  period              = 60 # 1 minute
  evaluation_periods  = 5
  datapoints_to_alarm = 1
}
