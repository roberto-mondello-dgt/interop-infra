resource "aws_cloudwatch_metric_alarm" "sqs_jwt_audit" {
  count = local.deploy_jwt_audit_resources ? 1 : 0

  depends_on = [aws_sqs_queue.jwt_audit[0]]

  alarm_name          = "sqs-${aws_sqs_queue.jwt_audit[0].name}-message-age-${var.env}"
  alarm_description   = "Age of oldest message in the queue"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "120" # 2 minutes
  alarm_actions       = [data.aws_sns_topic.platform_alarms.arn]
  treat_missing_data  = "notBreaching"
  dimensions = {
    QueueName = aws_sqs_queue.jwt_audit[0].name
  }
  datapoints_to_alarm = "1"
}