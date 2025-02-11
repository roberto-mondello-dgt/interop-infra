resource "aws_iam_policy" "be_jwt_audit_analytics_writer" {
  count = local.deploy_jwt_audit_resources ? 1 : 0

  name = "InteropBeJwtAuditAnalyticsWriter"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:ListBucket"
        Resource = data.aws_s3_bucket.jwt_audit_source.arn
      },
      {
        Effect   = "Allow"
        Action   = "s3:GetObject"
        Resource = format("%s/*", data.aws_s3_bucket.jwt_audit_source.arn)
      },
      {
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage"
        ]
        Resource = aws_sqs_queue.jwt_audit[0].arn
      },
    ]
  })
}