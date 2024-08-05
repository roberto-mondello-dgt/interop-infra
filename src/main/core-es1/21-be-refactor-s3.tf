module "be_refactor_application_documents_bucket" {
  count = var.env == "dev" ? 1 : 0

  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = format("interop-application-documents-refactor-%s-es1", var.env)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }
}

module "be_refactor_generated_jwt_details_bucket" {
  count = var.env == "dev" ? 1 : 0

  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = format("%s-generated-jwt-details-refactor-%s-es1", var.short_name, var.env)

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
}

module "be_refactor_generated_jwt_details_fallback_bucket" {
  count = var.env == "dev" ? 1 : 0

  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = format("%s-generated-jwt-details-fallback-refactor-%s-es1", var.short_name, var.env)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }

  metric_configuration = [
    {
      name   = "AllObjects"
      filter = []
    }
  ]

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

resource "aws_cloudwatch_metric_alarm" "be_refactor_generated_jwt_fallback_write_activity" {
  count = var.env == "dev" ? 1 : 0

  alarm_name        = format("generated-jwt-fallback-refactor-write-activity-%s", var.env)
  alarm_description = format("Write activity on %s bucket", module.be_refactor_generated_jwt_details_fallback_bucket[0].s3_bucket_id)

  alarm_actions = [aws_sns_topic.be_refactor_platform_alarms[0].arn]

  namespace   = "AWS/S3"
  metric_name = "PutRequests"

  dimensions = {
    BucketName = module.be_refactor_generated_jwt_details_fallback_bucket[0].s3_bucket_id
    FilterId   = "AllObjects"
  }

  comparison_operator = "GreaterThanThreshold"
  statistic           = "Sum"
  treat_missing_data  = "notBreaching"

  threshold           = 0
  period              = 60 # 1 minute
  evaluation_periods  = 30
  datapoints_to_alarm = 1
}
