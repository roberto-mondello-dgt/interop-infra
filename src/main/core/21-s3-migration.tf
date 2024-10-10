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
    # "interop-anac-sftp-${var.env}",
    "interop-ivass-${var.env}",
    "interop-s3-batch-reports-${var.env}",
    # "interop-data-preparation-${var.env}",
    "interop-frontend-additional-assets-${var.env}",
    "interop-application-import-export-${var.env}"
  ]
}

resource "aws_s3_bucket_replication_configuration" "s3_region_migration" {
  for_each = toset([for b in local.s3_migration_src_buckets : b if local.region_migration])

  bucket = each.value
  role   = aws_iam_role.s3_region_migration[0].arn

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
