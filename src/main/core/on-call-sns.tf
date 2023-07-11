resource "aws_sns_topic" "on_call_opsgenie" {
  name = format("%s-on-call-opsgenie-%s", var.short_name, var.env)
}

resource "aws_sns_topic_policy" "on_call_cw_alarms" {
  arn = aws_sns_topic.on_call_opsgenie.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
        Action   = "sns:Publish"
        Resource = aws_sns_topic.on_call_opsgenie.arn
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
