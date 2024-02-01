data "aws_s3_bucket" "privacy_notices" {
  count  = var.privacy_notices_bucket_name != null ? 1 : 0
  bucket = var.privacy_notices_bucket_name
}

data "aws_s3_bucket" "m2m_interface_specification" {
  count  = var.m2m_interface_specification_bucket_name != null ? 1 : 0
  bucket = var.m2m_interface_specification_bucket_name
}

locals {
  pp_object_key       = "consent/latest/*/pp.json"
  tos_object_key      = "consent/latest/*/tos.json"
  m2m_spec_object_key = "m2m/interface-specification.yaml"
}

data "aws_iam_policy_document" "apigw_assume" {
  count = (var.privacy_notices_bucket_name != null || var.m2m_interface_specification_bucket_name != null) ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "apigw_privacy_notices" {
  count = var.privacy_notices_bucket_name != null ? 1 : 0

  name               = format("interop-%s-apigw-privacy-notices-%s", var.api_name, var.env)
  assume_role_policy = data.aws_iam_policy_document.apigw_assume[0].json

  inline_policy {
    name = "GetPrivacyNotices"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect = "Allow"
        Action = ["s3:GetObject"]
        Resource = [
          "${data.aws_s3_bucket.privacy_notices[0].arn}/${local.pp_object_key}",
          "${data.aws_s3_bucket.privacy_notices[0].arn}/${local.tos_object_key}"
        ]
      }]
    })
  }
}

resource "aws_iam_role" "apigw_m2m_interface_specification" {
  count = var.m2m_interface_specification_bucket_name != null ? 1 : 0

  name               = format("interop-%s-apigw-m2m-spec-%s", var.api_name, var.env)
  assume_role_policy = data.aws_iam_policy_document.apigw_assume[0].json

  inline_policy {
    name = "GetM2MSpecification"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect = "Allow"
        Action = ["s3:GetObject"]
        Resource = [
          "${data.aws_s3_bucket.m2m_interface_specification[0].arn}/${local.m2m_spec_object_key}"
        ]
      }]
    })
  }
}
