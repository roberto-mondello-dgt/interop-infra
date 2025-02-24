locals {
  msk_iam_prefix = "arn:aws:kafka:${var.aws_region}:${data.aws_caller_identity.current.account_id}"

  msk_platform_events_cluster_name = (local.deploy_data_ingestion_resources ? data.aws_msk_cluster.platform_events.cluster_name : null)
  msk_platform_events_cluster_uuid = (local.deploy_data_ingestion_resources ? split("/", data.aws_msk_cluster.platform_events.arn)[2] : null)

  msk_topic_iam_prefix = (local.deploy_data_ingestion_resources ? "${local.msk_iam_prefix}:topic/${local.msk_platform_events_cluster_name}/${local.msk_platform_events_cluster_uuid}" : null)
  msk_group_iam_prefix = (local.deploy_data_ingestion_resources ? "${local.msk_iam_prefix}:group/${local.msk_platform_events_cluster_name}/${local.msk_platform_events_cluster_uuid}" : null)
}

resource "aws_iam_policy" "be_jwt_audit_analytics_writer" {
  count = local.deploy_data_ingestion_resources ? 1 : 0

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

resource "aws_iam_policy" "be_domains_analytics_writer" {
  count = local.deploy_data_ingestion_resources ? 1 : 0

  name = "InteropBeDomainsAnalyticsWriter"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kafka-cluster:AlterGroup",
          "kafka-cluster:Connect",
          "kafka-cluster:DescribeGroup",
          "kafka-cluster:DescribeTopic",
          "kafka-cluster:ReadData"
        ]
        Resource = [
          data.aws_msk_cluster.platform_events.arn,
          "${local.msk_topic_iam_prefix}/event-store.${var.env}_*.events",
          "${local.msk_group_iam_prefix}/${var.analytics_k8s_namespace}-domains-analytics-writer"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "application_audit" {
  count = local.deploy_data_ingestion_resources ? 1 : 0

  name = "InteropBeApplicationAuditProducerEs1"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kafka-cluster:Connect",
          "kafka-cluster:DescribeTopic",
          "kafka-cluster:ReadData",
          "kafka-cluster:WriteData"
        ]
        Resource = [
          data.aws_msk_cluster.platform_events.arn,
          "${local.msk_topic_iam_prefix}/${var.env}_application.audit",
        ]
      }
    ]
  })
}
