resource "aws_iam_policy" "be_refactor_catalog_process" {
  count = var.env == "dev" ? 1 : 0

  name = "InteropBeRefactorCatalogProcessPolicy"

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
