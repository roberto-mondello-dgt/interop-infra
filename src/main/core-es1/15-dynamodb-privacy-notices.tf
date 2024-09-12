resource "aws_dynamodb_table" "privacy_notices" {
  name         = format("interop-privacy-notices-%s", var.env)
  billing_mode = "PAY_PER_REQUEST"


  dynamic "import_table" {
    for_each = var.env == "att" ? [true] : []

    content {

      input_compression_type = "GZIP"
      input_format           = "DYNAMODB_JSON"

      s3_bucket_source {
        bucket     = "interop-dynamodb-exports-${var.env}"
        key_prefix = "eu-central-1/interop-privacy-notices-${var.env}/AWSDynamoDB/01726128154951-247a1d70/data"
      }
    }
  }

  hash_key = "privacyNoticeId"

  attribute {
    name = "privacyNoticeId"
    type = "S"
  }
}

resource "aws_dynamodb_table" "privacy_notices_acceptances" {
  name         = format("interop-privacy-notices-acceptances-%s", var.env)
  billing_mode = "PAY_PER_REQUEST"

  dynamic "import_table" {
    for_each = var.env == "att" ? [true] : []

    content {
      input_compression_type = "GZIP"
      input_format           = "DYNAMODB_JSON"

      s3_bucket_source {
        bucket     = "interop-dynamodb-exports-${var.env}"
        key_prefix = "eu-central-1/interop-privacy-notices-acceptances-${var.env}/AWSDynamoDB/01726128130483-72d0543b/data"
      }
    }
  }

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
