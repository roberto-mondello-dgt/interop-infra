resource "aws_iam_policy" "be_refactor_catalog_process" {
  count = var.env == "dev" ? 1 : 0

  name = "InteropBeCatalogProcessRefactorPolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = format("%s/*", module.application_documents_refactor_bucket[0].s3_bucket_arn)
      }
    ]
  })
}

locals {
  msk_topic_iam_prefix = (var.env == "dev"
    ? "${local.msk_iam_prefix}:topic/${local.interop_events_cluster_name}/${local.interop_events_cluster_uuid}"
  : null)
  msk_group_iam_prefix = (var.env == "dev"
    ? "${local.msk_iam_prefix}:group/${local.interop_events_cluster_name}/${local.interop_events_cluster_uuid}"
  : null)
}


resource "aws_iam_policy" "be_refactor_msk_catalog_public_topic_reader" {
  count = var.env == "dev" ? 1 : 0

  name = "InteropBeMskTopicCatalogPublicReader"

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
          aws_msk_serverless_cluster.interop_events[0].arn,
          "${local.msk_topic_iam_prefix}/catalog.public.event",
          "${local.msk_group_iam_prefix}/*"
        ]
      }
    ]
  })
}
