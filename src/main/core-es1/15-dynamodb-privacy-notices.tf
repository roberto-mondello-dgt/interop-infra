resource "aws_dynamodb_table" "privacy_notices" {
  name         = format("interop-privacy-notices-%s", var.env)
  billing_mode = "PAY_PER_REQUEST"

  import_table {
    input_compression_type = "GZIP"
    input_format           = "DYNAMODB_JSON"

    s3_bucket_source {
      bucket     = "interop-dynamodb-exports-dev"
      key_prefix = "eu-central-1/interop-privacy-notices-dev/AWSDynamoDB/01722262445541-7f074a67/data"
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

  import_table {
    input_compression_type = "GZIP"
    input_format           = "DYNAMODB_JSON"

    s3_bucket_source {
      bucket     = "interop-dynamodb-exports-dev"
      key_prefix = "eu-central-1/interop-privacy-notices-acceptances-dev/AWSDynamoDB/01722262424385-def70228/data"
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
