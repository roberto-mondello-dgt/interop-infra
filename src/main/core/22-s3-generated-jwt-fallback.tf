resource "aws_secretsmanager_secret" "generated_jwt_fallback_replication_token" {
  count = var.env == "dev" ? 1 : 0

  name = "generated-jwt-fallback-replication-token"
}

data "aws_secretsmanager_secret_version" "generated_jwt_fallback_replication_token" {
  count = var.env == "dev" ? 1 : 0

  secret_id = aws_secretsmanager_secret.generated_jwt_fallback_replication_token[0].id
}

module "generated_jwt_details_fallback_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.8.2"

  bucket = format("%s-generated-jwt-details-fallback-%s", var.short_name, var.env)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }

  object_lock_enabled = true
  object_lock_configuration = {
    rule = {
      default_retention = {
        mode  = var.env == "prod" ? "COMPLIANCE" : "GOVERNANCE"
        years = 10
      }
    }
  }

  lifecycle_rule = [
    {
      id         = "RetentionRule"
      enabled    = true
      expiration = { days : 3650 } # delete after 10 years
      transition = {
        days : 30
        storage_class : "STANDARD_IA"
      }
    }
  ]
}

resource "aws_iam_role" "generated_jwt_details_fallback_replication" {
  name = format("%s-generated-jwt-details-fallback-replication-%s", var.short_name, var.env)

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  inline_policy {
    name = "ReplicateFallbackToMain"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "s3:GetReplicationConfiguration",
            "s3:ListBucket"
          ],
          Resource = module.generated_jwt_details_bucket.s3_bucket_arn
        },
        {
          Effect = "Allow"
          Action = [
            "s3:GetObjectVersionForReplication",
            "s3:GetObjectVersionAcl",
            "s3:GetObjectVersionTagging",
            "s3:GetObjectRetention",
            "s3:GetObjectLegalHold"
          ],
          Resource = format("%s/*", module.generated_jwt_details_bucket.s3_bucket_arn)
        },
        {
          Effect = "Allow"
          Action = [
            "s3:ReplicateObject",
            "s3:ReplicateDelete",
            "s3:ReplicateTags"
          ],
          Resource = format("%s/*", module.generated_jwt_details_fallback_bucket.s3_bucket_arn)
        }
      ]
    })
  }
}

resource "aws_s3_bucket_replication_configuration" "generated_jwt_details_fallback" {
  count = var.env == "dev" ? 1 : 0

  bucket = module.generated_jwt_details_fallback_bucket.s3_bucket_id
  role   = aws_iam_role.generated_jwt_details_fallback_replication.arn

  token = data.aws_secretsmanager_secret_version.generated_jwt_fallback_replication_token[0].secret_string

  rule {
    id = "ReplicateToMainBucket"

    status = "Enabled"

    filter {
      prefix = ""
    }

    delete_marker_replication {
      status = "Disabled"
    }

    destination {
      bucket        = module.generated_jwt_details_bucket.s3_bucket_arn
      storage_class = "STANDARD"


      replication_time {
        status = "Enabled"

        time {
          minutes = 15
        }
      }

      metrics {
        status = "Enabled"

        event_threshold {
          minutes = 15
        }
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "generated_jwt_fallback_replication_failed" {
  count = var.env == "dev" ? 1 : 0

  alarm_name        = format("generated-jwt-fallback-replication-failed-%s", var.env)
  alarm_description = "Object replication errors from fallback bucket to main bucket"

  alarm_actions = [aws_sns_topic.platform_alarms.arn]

  namespace   = "S3"
  metric_name = "OperationsFailedReplication"

  dimensions = {
    SourceBucket = module.generated_jwt_details_fallback_bucket.s3_bucket_id
    RuleId       = aws_s3_bucket_replication_configuration.generated_jwt_details_fallback[0].rule[0].id
  }

  comparison_operator = "GreaterThanOrEqualToThreshold"
  statistic           = "Sum"
  treat_missing_data  = "notBreaching"

  threshold           = 1
  period              = 60 # 1 minute
  evaluation_periods  = 60
  datapoints_to_alarm = 1
}
