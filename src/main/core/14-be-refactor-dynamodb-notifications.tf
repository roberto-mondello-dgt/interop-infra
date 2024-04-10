resource "aws_dynamodb_table" "be_refactor_notification_events" {
  count = var.env == "dev" ? 1 : 0

  name         = "interop-notification-events-refactor"
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

resource "aws_dynamodb_table" "be_refactor_notification_resources" {
  count = var.env == "dev" ? 1 : 0

  name         = "interop-notification-resources-refactor"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "resourceId"

  attribute {
    name = "resourceId"
    type = "S"
  }
}
