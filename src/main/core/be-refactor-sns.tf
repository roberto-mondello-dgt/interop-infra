resource "aws_sns_topic" "be_refactor_platform_alarms" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = format("interop-platform-alarms-refactor-%s", var.env)
}

resource "aws_sns_topic_policy" "be_refactor_platform_alarms" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  arn = aws_sns_topic.be_refactor_platform_alarms[0].arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudWatchAlarms"
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
        Action   = "sns:Publish"
        Resource = aws_sns_topic.be_refactor_platform_alarms[0].arn
        Condition = {
          ArnLike = {
            "aws:SourceArn" = "arn:aws:cloudwatch:${var.aws_region}:${data.aws_caller_identity.current.account_id}:alarm:*"
          }
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      },
      {
        Sid    = "AllowEventBridge"
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action   = "sns:Publish"
        Resource = aws_sns_topic.be_refactor_platform_alarms[0].arn
      }
    ]
  })
}
