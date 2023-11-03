data "aws_iam_policy_document" "cfn_full_admin_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["cloudformation.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cfn_full_admin" {
  name                = format("%s-iam-users-%s-CFNFullAdminRole", var.short_name, var.env)
  assume_role_policy  = data.aws_iam_policy_document.cfn_full_admin_assume_policy.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

resource "aws_iam_policy" "user_credentials_self_service" {
  count = (var.env == "dev") ? 1 : 0

  name = "UserCredentialsSelfService"
  policy = templatefile("./iam_policies/user_credentials_self_service.tftpl.json",
    {
      account_id = data.aws_caller_identity.current.account_id
  })
}

resource "aws_iam_group" "external_backend_devs" {
  count = (var.env == "dev") ? 1 : 0

  name = "ExternalBackendDevelopers"
  path = "/externals/engineers/backend/"
}

resource "aws_iam_group_policy_attachment" "external_backend_devs_credentials" {
  count = (var.env == "dev") ? 1 : 0

  group      = aws_iam_group.external_backend_devs[0].name
  policy_arn = aws_iam_policy.user_credentials_self_service[0].arn
}

data "aws_iam_policy" "read_only" {
  name = "ReadOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "external_backend_devs_read_only" {
  count = (var.env == "dev") ? 1 : 0

  group      = aws_iam_group.external_backend_devs[0].name
  policy_arn = data.aws_iam_policy.read_only.arn
}

resource "aws_iam_role" "data_lake_tokens" {
  name = format("%s-datalake-bucket-token-%s", var.short_name, var.env)

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

resource "aws_iam_role" "data_lake_metrics" {
  name = format("%s-datalake-platform-metrics-%s", var.short_name, var.env)

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
