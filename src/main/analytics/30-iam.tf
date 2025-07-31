resource "aws_iam_role" "analytics_scheduled_actions" {
  count = local.deploy_redshift_cluster ? 1 : 0

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
          Resource = aws_redshift_cluster.analytics[0].arn
        }
      ]
    })
  }
}

resource "aws_iam_role" "redshift_describe_clusters" {
  count = local.deploy_redshift_cluster && var.redshift_enable_cross_account_access_account_id != null ? 1 : 0

  name = format("%s-redshift-describe-clusters-cross-account-access-%s-es1", local.project, var.env)

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = "sts:AssumeRole"
      Principal = {
        AWS = "arn:aws:iam::${var.redshift_enable_cross_account_access_account_id}:root"
      },
      Condition = {
        ArnLike = {
          "aws:PrincipalArn" = "arn:aws:iam::${var.redshift_enable_cross_account_access_account_id}:role/aws-reserved/sso.amazonaws.com/*/AWSReservedSSO_*"
        }
      }
    }]
  })

  inline_policy {
    name = "RedshiftDescribeClustersCrossAccountPolicy"

    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [{
        Effect = "Allow",
        Action = [
          "redshift:DescribeClusters",
          "redshift:DescribeLoggingStatus"
        ]
        Resource = "*"
      }]
    })
  }
}
