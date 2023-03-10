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
}

resource "aws_dynamodb_table" "notification_resources" {
  name         = "interop-notification-resources"
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "resourceId"

  attribute {
    name = "resourceId"
    type = "S"
  }
}
