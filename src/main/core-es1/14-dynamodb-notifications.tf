resource "aws_dynamodb_table" "notification_events" {
  name         = "interop-notification-events"
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "organizationId"
  range_key = "eventId"

  attribute {
    name = "organizationId"
    type = "S"
  }

  attribute {
    name = "eventId"
    type = "N"
  }

  ttl {
    attribute_name = "ttl"
    enabled        = var.notification_events_table_ttl_enabled
  }

  dynamic "import_table" {
    for_each = var.env == "test" ? [true] : []

    content {
      input_compression_type = "GZIP"
      input_format           = "DYNAMODB_JSON"

      s3_bucket_source {
        bucket     = "interop-dynamodb-exports-${var.env}"
        key_prefix = "eu-central-1/interop-notification-events/AWSDynamoDB/01725525672417-e9b12c93/data"
      }
    }
  }
}

resource "aws_dynamodb_table" "notification_resources" {
  name         = "interop-notification-resources"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "resourceId"

  attribute {
    name = "resourceId"
    type = "S"
  }


  dynamic "import_table" {
    for_each = var.env == "test" ? [true] : []

    content {
      input_compression_type = "GZIP"
      input_format           = "DYNAMODB_JSON"

      s3_bucket_source {
        bucket     = "interop-dynamodb-exports-${var.env}"
        key_prefix = "eu-central-1/interop-notification-resources/AWSDynamoDB/01725525735056-961744fd/data"
      }
    }
  }
}
