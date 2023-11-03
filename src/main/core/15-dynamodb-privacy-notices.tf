resource "aws_dynamodb_table" "privacy_notices" {
  name         = format("interop-privacy-notices-%s", var.env)
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "privacyNoticeId"

  attribute {
    name = "privacyNoticeId"
    type = "S"
  }
}

resource "aws_dynamodb_table" "privacy_notices_acceptances" {
  name         = format("interop-privacy-notices-acceptances-%s", var.env)
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "pnIdWithUserId"
  range_key = "versionNumber"

  attribute {
    name = "pnIdWithUserId"
    type = "S"
  }

  attribute {
    name = "versionNumber"
    type = "N"
  }
}
