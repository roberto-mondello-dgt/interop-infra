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


resource "aws_iam_policy" "be_refactor_catalog_process" {
  count = var.env == "dev" ? 1 : 0

  name = "InteropBeEventConsumerRefactorPolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kafka-cluster:Connect",
          "kafka-cluster:DescribeTopic",
          "kafka-cluster:ReadData",
        ]
        # TODO: restrict to specific topics
        Resource = [
          "${local.msk_iam_prefix}:*/${local.interop_events_cluster_name}/${local.interop_events_cluster_uuid}",
          "${local.msk_iam_prefix}:*/${local.interop_events_cluster_name}/${local.interop_events_cluster_uuid}/*"
        ]
      }
    ]
  })
}
