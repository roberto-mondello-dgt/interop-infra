# TODO: refactor?
locals {
  frontend_env_cors_domain = (var.env != "prod" ?
  format("selfcare.%s.%s", local.env_dns_name, var.dns_interop_base_domain) : format("selfcare.%s", var.dns_interop_base_domain))
}

# TODO: update S3 module and remove "acl" value after new AWS defaults?

module "jwt_well_known_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = format("%s-jwt-well-known-%s", var.short_name, var.env)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }

  attach_policy = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action = [
          "s3:GetObject",
        ]
        Resource = "${module.jwt_well_known_bucket.s3_bucket_arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.landing.arn
          }
        }
      }
    ]
  })

}

module "application_documents_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = format("%s-application-documents-%s", var.short_name, var.env)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
}

module "cfn_templates_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = format("%s-cfn-templates-%s", var.short_name, var.env)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }
}

module "open_api_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = format("%s-open-api-%s", var.short_name, var.env)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }
}

module "generated_jwt_details_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = format("%s-generated-jwt-details-%s", var.short_name, var.env)

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
      id         = "GlacierRule"
      enabled    = false           # TODO: move to S3-IA instead? Need to handle existing objects in Glacier
      expiration = { days : 3650 } # delete after 10 years
      transition = {
        days : 365
        storage_class : "GLACIER"
      }
    }
  ]
}

module "data_lake_exports_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = format("%s-data-lake-exports-%s", var.short_name, var.env)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = false
  }
}

module "application_logs_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = format("%s-application-logs-%s", var.short_name, var.env)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }

  attach_policy = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service : ["logs.${var.aws_region}.amazonaws.com"]
        }
        Action   = "s3:GetBucketAcl"
        Resource = module.application_logs_bucket.s3_bucket_arn
      },
      {
        Effect = "Allow"
        Principal = {
          Service : ["logs.${var.aws_region}.amazonaws.com"]
        }
        Action   = "s3:PutObject"
        Resource = "${module.application_logs_bucket.s3_bucket_arn}/*"
      }
    ]
  })
}

module "athena_query_results_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = format("%s-athena-query-results-%s", var.short_name, var.env)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }

  lifecycle_rule = [
    {
      id         = "Expiration"
      enabled    = true
      expiration = { days : 31 } # delete after 31 days
    }
  ]
}

module "platform_metrics_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = format("%s-platform-metrics-%s", var.short_name, var.env)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = false
  }
}

module "allow_list_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = format("%s-allow-list-%s", var.short_name, var.env)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }
}

module "public_dashboards_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = format("%s-public-dashboards-%s", var.short_name, var.env)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }

  cors_rule = var.env != "test" ? [] : [
    {
      allowed_headers = ["*"]
      allowed_methods = ["GET"]
      allowed_origins = ["https://www.interop.pagopa.it"]
    }
  ]

  attach_policy = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action = [
          "s3:GetObject",
        ]
        Resource = "${module.public_dashboards_bucket.s3_bucket_arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.landing.arn
          }
        }
      }
    ]
  })
}

module "probing_eservices_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = format("%s-probing-eservices-%s", var.short_name, var.env)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }

  attach_policy = var.probing_registry_reader_role_arn != null
  policy = var.probing_registry_reader_role_arn != null ? jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS : var.probing_registry_reader_role_arn
        }
        Action = [
          "s3:GetObject",
          "s3:ListBucketVersions",
          "s3:ListBucket",
          "s3:GetObjectVersion"
        ]
        Resource = [
          module.probing_eservices_bucket.s3_bucket_arn,
          "${module.probing_eservices_bucket.s3_bucket_arn}/*"
        ]
      }
    ]
  }) : null
}


module "metrics_reports_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = format("%s-metrics-reports-%s", var.short_name, var.env)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = false
  }
}

module "interop_landing_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = format("%s-landing-%s", var.short_name, var.env)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = false
  }

  attach_policy = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action = [
          "s3:GetObject",
        ]
        Resource = "${module.interop_landing_bucket.s3_bucket_arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.landing.arn
          }
        }
      }
    ]
  })
}

module "public_catalog_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = format("%s-public-catalog-%s", var.short_name, var.env)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = false
  }

  attach_policy = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action = [
          "s3:GetObject",
        ]
        Resource = "${module.public_catalog_bucket.s3_bucket_arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.landing.arn
          }
        }
      }
    ]
  })
}

module "privacy_notices_history_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = format("%s-privacy-notices-history-%s", var.short_name, var.env)

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
        # TODO: use conditional version below when ready to lock
        # mode  = var.env == "prod" ? "COMPLIANCE" : "GOVERNANCE"
        mode  = "GOVERNANCE"
        years = 10
      }
    }
  }
}

module "privacy_notices_content_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = format("%s-privacy-notices-content-%s", var.short_name, var.env)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = false
  }
}

# TODO: refactor this bucket, the contents can be exposed by other AWS services
module "public_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = format("%s-%s-public", var.short_name, var.env)

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  versioning = {
    enabled = false
  }

  cors_rule = [
    {
      allowed_headers = ["*"]
      allowed_methods = ["GET", "HEAD"]
      allowed_origins = ["https://${local.frontend_env_cors_domain}"]
    }
  ]

  attach_policy = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
        ]
        Resource = "${module.public_bucket.s3_bucket_arn}/*"
      }
    ]
  })
}

module "alb_logs_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = format("%s-alb-logs-%s", var.short_name, var.env)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = false
  }

  lifecycle_rule = [
    {
      id         = "Expiration"
      enabled    = true
      expiration = { days : var.env == "prod" ? 93 : 32 }
    }
  ]

  attach_policy = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          "AWS" = "arn:aws:iam::054676820928:root" # ELB account id for eu-central-1. See https://docs.aws.amazon.com/elasticloadbalancing/latest/application/enable-access-logging.html
        }
        Action   = "s3:PutObject"
        Resource = "${module.alb_logs_bucket.s3_bucket_arn}/*"
      }
    ]
  })
}

module "anac_sftp_bucket" {
  count = local.deploy_anac_sftp ? 1 : 0

  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = format("%s-anac-sftp-%s", var.short_name, var.env)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = false
  }
}

module "ivass_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.8.2"

  bucket = format("%s-ivass-%s", var.short_name, var.env)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = false
  }
}

module "s3_batch_reports_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = format("%s-s3-batch-reports-%s", var.short_name, var.env)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = false
  }
}

module "msk_custom_plugins_bucket" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.14.1"

  bucket = format("interop-msk-custom-plugins-%s", var.env)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }
}

module "data_preparation_bucket" {
  count = var.env == "qa" ? 1 : 0

  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.14.1"

  bucket = format("interop-data-preparation-%s", var.env)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }
}

module "frontend_additional_assets_bucket" {
  count = local.deploy_new_bff_apigw ? 1 : 0

  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.14.1"

  bucket = format("interop-frontend-additional-assets-%s", var.env)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = false
  }
}
