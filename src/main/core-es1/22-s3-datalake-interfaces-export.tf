locals {
  data_lake_replicate_interfaces = var.data_lake_interfaces_bucket_arn != null
}

resource "aws_iam_role" "datalake_interfaces_s3_replication" {
  name = format("%s-datalake-interfaces-s3-replication-%s-es1", var.short_name, var.env)

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect : "Allow",
        Principal : {
          Service : [
            "s3.amazonaws.com",
            "batchoperations.s3.amazonaws.com"
          ]
        },
        Action : "sts:AssumeRole"
      }
    ]
  })

  dynamic "inline_policy" {
    for_each = local.data_lake_replicate_interfaces ? [1] : []

    content {
      name = "InteropDataLakeInterfacesS3Replication"

      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "s3:GetReplicationConfiguration",
              "s3:ListBucket"
            ],
            Resource = module.datalake_interfaces_export_bucket.s3_bucket_arn
          },
          {
            Effect = "Allow"
            Action = [
              "s3:GetObjectVersionForReplication",
              "s3:GetObjectVersionAcl",
              "s3:GetObjectVersionTagging"
            ],
            Resource = format("%s/*", module.datalake_interfaces_export_bucket.s3_bucket_arn)
          },
          {
            Effect = "Allow"
            Action = [
              "s3:ReplicateObject",
              "s3:ReplicateDelete",
              "s3:ReplicateTags"
            ],
            Resource = format("%s/*", var.data_lake_interfaces_bucket_arn)
          }
        ]
      })
    }
  }
}

resource "aws_s3_bucket_replication_configuration" "datalake_interfaces_export" {
  count = local.data_lake_replicate_interfaces ? 1 : 0

  bucket = module.datalake_interfaces_export_bucket.s3_bucket_id
  role   = aws_iam_role.datalake_interfaces_s3_replication.arn

  rule {
    id = "ReplicateToDataLakeBucket"

    status = "Enabled"

    filter {
      prefix = ""
    }

    delete_marker_replication {
      status = "Disabled"
    }

    destination {
      bucket        = var.data_lake_interfaces_bucket_arn
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

resource "aws_cloudwatch_metric_alarm" "datalake_interfaces_export_replication_failed" {
  count = local.data_lake_replicate_interfaces ? 1 : 0

  alarm_name        = format("s3-datalake-interfaces-export-replication-failed-%s", var.env)
  alarm_description = "Object replication errors from ${module.datalake_interfaces_export_bucket.s3_bucket_id} bucket to DataLake"

  alarm_actions = [aws_sns_topic.platform_alarms.arn]

  namespace   = "AWS/S3"
  metric_name = "OperationsFailedReplication"

  dimensions = {
    SourceBucket      = module.datalake_interfaces_export_bucket.s3_bucket_id
    RuleId            = aws_s3_bucket_replication_configuration.datalake_interfaces_export[0].rule[0].id
    DestinationBucket = replace(var.data_lake_interfaces_bucket_arn, "arn:aws:s3:::", "")
  }

  comparison_operator = "GreaterThanThreshold"
  statistic           = "Sum"
  treat_missing_data  = "notBreaching"

  threshold           = 0
  period              = 60 # 1 minute
  evaluation_periods  = 30
  datapoints_to_alarm = 1
}
