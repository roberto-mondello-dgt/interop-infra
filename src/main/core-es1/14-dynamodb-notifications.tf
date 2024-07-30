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

  import_table {
    input_compression_type = "GZIP"
    input_format           = "DYNAMODB_JSON"

    s3_bucket_source {
      bucket     = "interop-dynamodb-exports-dev"
      key_prefix = "eu-central-1/interop-notification-events/AWSDynamoDB/01722262267831-c80be986/data"
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

  import_table {
    input_compression_type = "GZIP"
    input_format           = "DYNAMODB_JSON"

    s3_bucket_source {
      bucket     = "interop-dynamodb-exports-dev"
      key_prefix = "eu-central-1/interop-notification-resources/AWSDynamoDB/01722262293086-6e9cf9d3/data"
    }
  }
}
