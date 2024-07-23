locals {
  data_lake_access_enabled = var.data_lake_account_id != null && var.data_lake_external_id != null
}

resource "aws_iam_role" "data_lake_tokens" {
  count = local.data_lake_access_enabled ? 1 : 0

  name = format("%s-datalake-bucket-token-%s-es1", var.short_name, var.env)

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = var.data_lake_account_id
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.data_lake_external_id
          }
        }
      }
    ]
  })

  inline_policy {
    name = "DataLakeBucketTokenPolicy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = "s3:GetObject"
          Resource = "${module.generated_jwt_details_bucket.s3_bucket_arn}/*"
        },
        {
          Effect   = "Allow"
          Action   = "s3:ListBucket"
          Resource = module.generated_jwt_details_bucket.s3_bucket_arn
        }
      ]
    })
  }
}

resource "aws_iam_role" "data_lake_exports" {
  count = local.data_lake_access_enabled ? 1 : 0

  name = format("%s-datalake-bucket-exports-%s-es1", var.short_name, var.env)

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = var.data_lake_account_id
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.data_lake_external_id
          }
        }
      }
    ]
  })

  inline_policy {
    name = "DataLakeBucketExportsPolicy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = "s3:GetObject"
          Resource = "${module.data_lake_exports_bucket.s3_bucket_arn}/*"
        },
        {
          Effect   = "Allow"
          Action   = "s3:ListBucket"
          Resource = module.data_lake_exports_bucket.s3_bucket_arn
        }
      ]
    })
  }
}

resource "aws_iam_role" "data_lake_metrics" {
  count = local.data_lake_access_enabled ? 1 : 0

  name = format("%s-datalake-platform-metrics-%s-es1", var.short_name, var.env)

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = var.data_lake_account_id
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.data_lake_external_id
          }
        }
      }
    ]
  })

  inline_policy {
    name = "DataLakePlatformMeticsBucketPolicy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = "s3:GetObject"
          Resource = "${module.platform_metrics_bucket.s3_bucket_arn}/*"
        },
        {
          Effect   = "Allow"
          Action   = "s3:ListBucket"
          Resource = module.platform_metrics_bucket.s3_bucket_arn
        }
      ]
    })
  }
}
