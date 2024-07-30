locals {
  s3_migration_src_buckets = [
    "interop-jwt-well-known-${var.env}",
    "interop-application-documents-${var.env}",
    "interop-generated-jwt-details-${var.env}",
    "interop-data-lake-exports-${var.env}",
    "interop-application-logs-${var.env}",
    "interop-athena-query-results-${var.env}",
    "interop-platform-metrics-${var.env}",
    "interop-allow-list-${var.env}",
    "interop-public-dashboards-${var.env}",
    "interop-probing-eservices-${var.env}",
    "interop-metrics-reports-${var.env}",
    "interop-landing-${var.env}",
    "interop-public-catalog-${var.env}",
    "interop-privacy-notices-history-${var.env}",
    "interop-privacy-notices-content-${var.env}",
    "interop-${var.env}-public",
    "interop-alb-logs-${var.env}",
    "interop-anac-sftp-${var.env}",
    "interop-ivass-${var.env}",
    "interop-s3-batch-reports-${var.env}",
    "interop-data-preparation-${var.env}",
    "interop-frontend-additional-assets-${var.env}",
    "interop-application-import-export-${var.env}"
  ]
}

resource "aws_secretsmanager_secret" "s3_region_migration_generated_jwt_details_replication_token" {
  count = local.region_migration ? 1 : 0

  name = "s3-region-migration-generated-jwt-details-replication-token"
}

data "aws_secretsmanager_secret_version" "s3_region_migration_generated_jwt_details_replication_token" {
  count = local.region_migration ? 1 : 0

  secret_id = aws_secretsmanager_secret.s3_region_migration_generated_jwt_details_replication_token[0].id
}

resource "aws_s3_bucket_replication_configuration" "s3_region_migration" {
  for_each = toset([for b in local.s3_migration_src_buckets : b if local.region_migration])

  bucket = each.value
  role   = aws_iam_role.s3_region_migration[0].arn

  token = (each.value == "interop-generated-jwt-details-${var.env}" ?
    data.aws_secretsmanager_secret_version.s3_region_migration_generated_jwt_details_replication_token[0].secret_string
  : null)

  rule {
    id = "RegionMigration"

    status = "Enabled"

    filter {
      prefix = ""
    }

    delete_marker_replication {
      status = "Disabled"
    }

    destination {
      bucket = format("arn:aws:s3:::%s-es1", each.value)

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
