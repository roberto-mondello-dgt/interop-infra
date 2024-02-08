resource "aws_dynamodb_table" "be_refactor_privacy_notices" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name         = format("interop-privacy-notices-refactor-%s", var.env)
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "privacyNoticeId"

  attribute {
    name = "privacyNoticeId"
    type = "S"
  }
}

resource "aws_dynamodb_table" "be_refactor_privacy_notices_acceptances" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name         = format("interop-privacy-notices-acceptances-refactor-%s", var.env)
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
