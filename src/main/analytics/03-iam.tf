resource "aws_iam_role" "analytics_scheduled_actions" {
  name = format("%s-analytics-scheduled-actions-%s-es1", local.project, var.env)

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "scheduler.redshift.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  inline_policy {
    name = "AnalyticsScheduledActionsPolicy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "redshift:PauseCluster",
            "redshift:ResumeCluster"
          ]
          Resource = aws_redshift_cluster.analytics.arn
        }
      ]
    })
  }
}
