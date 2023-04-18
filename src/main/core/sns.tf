resource "aws_sns_topic" "logs_automation_errors" {
  name = format("%s-logs-automation-errors-%s", var.short_name, var.env)
}

resource "aws_sns_topic_policy" "logs_automation_errors" {
  arn = aws_sns_topic.logs_automation_errors.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action = "sns:Publish"
        Resource = aws_sns_topic.logs_automation_errors.arn
      }
    ]
  })
}

resource "aws_sns_topic" "platform_alarms" {
  name = format("%s-platform-alarms-%s", var.short_name, var.env)
}

resource "aws_sns_topic_policy" "platform_alarms" {
  arn = aws_sns_topic.platform_alarms.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
        Action = "sns:Publish"
        Resource = aws_sns_topic.platform_alarms.arn
        Condition = {
          ArnLike = {
            "aws:SourceArn" = "arn:aws:cloudwatch:${var.aws_region}:${data.aws_caller_identity.current.account_id}:alarm:*"
          }
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}
