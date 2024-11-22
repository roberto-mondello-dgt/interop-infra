data "aws_s3_bucket" "jwt_details_bucket" {
  bucket = var.jwt_details_bucket_name
}

resource "aws_iam_role" "generated_jwt_loader" {
  name = format("%s-analytics-generated-jwt-loader-%s-es1", local.project, var.env)

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "redshift.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  inline_policy {
    name = "AnalyticsGeneratedJWTLoaderPolicy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = "s3:GetObject"
          Resource = [
            "${data.aws_s3_bucket.jwt_details_bucket.arn}/*",
            "${module.analytics_jsonpaths.s3_bucket_arn}/*"
          ]
        },
        {
          Effect = "Allow"
          Action = "s3:ListBucket"
          Resource = [
            data.aws_s3_bucket.jwt_details_bucket.arn,
            module.analytics_jsonpaths.s3_bucket_arn
          ]
        }
      ]
    })
  }
}

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
