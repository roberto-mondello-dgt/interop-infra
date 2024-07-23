data "aws_s3_bucket" "privacy_notices" {
  count = var.is_bff && var.privacy_notices_bucket_name != null ? 1 : 0

  bucket = var.privacy_notices_bucket_name
}

locals {
  pp_object_key  = "consent/latest/*/pp.json"
  tos_object_key = "consent/latest/*/tos.json"
}

data "aws_iam_policy_document" "apigw_assume" {
  count = var.is_bff && var.privacy_notices_bucket_name != null ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "apigw_privacy_notices" {
  count = var.is_bff && var.privacy_notices_bucket_name != null ? 1 : 0

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

resource "aws_api_gateway_resource" "consent" {
  count = var.is_bff && var.privacy_notices_bucket_name != null ? 1 : 0

  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.this.id

  path_part = "consent"
}

resource "aws_api_gateway_resource" "consent_latest" {
  count = var.is_bff && var.privacy_notices_bucket_name != null ? 1 : 0

  parent_id   = aws_api_gateway_resource.consent[0].id
  rest_api_id = aws_api_gateway_rest_api.this.id

  path_part = "latest"
}

resource "aws_api_gateway_resource" "consent_latest_lang" {
  count = var.is_bff && var.privacy_notices_bucket_name != null ? 1 : 0

  parent_id   = aws_api_gateway_resource.consent_latest[0].id
  rest_api_id = aws_api_gateway_rest_api.this.id

  path_part = "{lang}"
}

resource "aws_api_gateway_resource" "consent_latest_lang_pp" {
  count = var.is_bff && var.privacy_notices_bucket_name != null ? 1 : 0

  parent_id   = aws_api_gateway_resource.consent_latest_lang[0].id
  rest_api_id = aws_api_gateway_rest_api.this.id

  path_part = "pp.json"
}

resource "aws_api_gateway_resource" "consent_latest_lang_tos" {
  count = var.is_bff && var.privacy_notices_bucket_name != null ? 1 : 0

  parent_id   = aws_api_gateway_resource.consent_latest_lang[0].id
  rest_api_id = aws_api_gateway_rest_api.this.id

  path_part = "tos.json"
}

resource "aws_api_gateway_method" "get_pp" {
  count = var.is_bff && var.privacy_notices_bucket_name != null ? 1 : 0

  resource_id = aws_api_gateway_resource.consent_latest_lang_pp[0].id
  rest_api_id = aws_api_gateway_rest_api.this.id

  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.lang" = true
  }
}

resource "aws_api_gateway_method" "get_tos" {
  count = var.is_bff && var.privacy_notices_bucket_name != null ? 1 : 0

  resource_id = aws_api_gateway_resource.consent_latest_lang_tos[0].id
  rest_api_id = aws_api_gateway_rest_api.this.id

  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.lang" = true
  }
}

locals {
  pn_resources = var.is_bff && var.privacy_notices_bucket_name != null ? {
    pp = {
      resource_id = aws_api_gateway_resource.consent_latest_lang_pp[0].id
      path_part   = aws_api_gateway_resource.consent_latest_lang_pp[0].path_part
      method      = aws_api_gateway_method.get_pp[0].http_method
    }

    tos = {
      resource_id = aws_api_gateway_resource.consent_latest_lang_tos[0].id
      path_part   = aws_api_gateway_resource.consent_latest_lang_tos[0].path_part
      method      = aws_api_gateway_method.get_tos[0].http_method
    }
  } : {}
}

resource "aws_api_gateway_integration" "pn_s3_integration" {
  for_each = local.pn_resources

  http_method = each.value.method
  resource_id = each.value.resource_id
  rest_api_id = aws_api_gateway_rest_api.this.id

  request_parameters = {
    "integration.request.path.lang" = "method.request.path.lang"
  }

  integration_http_method = "GET"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:s3:path/${data.aws_s3_bucket.privacy_notices[0].bucket}/consent/latest/{lang}/${each.value.path_part}"
  credentials             = aws_iam_role.apigw_privacy_notices[0].arn
}

resource "aws_api_gateway_method_response" "pn_s3_200" {
  for_each   = local.pn_resources
  depends_on = [aws_api_gateway_integration.pn_s3_integration]

  resource_id = each.value.resource_id
  http_method = each.value.method
  rest_api_id = aws_api_gateway_rest_api.this.id

  status_code = "200"

  response_parameters = {
    "method.response.header.Timestamp"      = true
    "method.response.header.Content-Length" = true
    "method.response.header.Content-Type"   = true
  }
}

resource "aws_api_gateway_method_response" "pn_s3_404" {
  for_each   = local.pn_resources
  depends_on = [aws_api_gateway_integration.pn_s3_integration]

  resource_id = each.value.resource_id
  http_method = each.value.method
  rest_api_id = aws_api_gateway_rest_api.this.id

  status_code = "404"
}

resource "aws_api_gateway_method_response" "pn_s3_500" {
  for_each   = local.pn_resources
  depends_on = [aws_api_gateway_integration.pn_s3_integration]

  resource_id = each.value.resource_id
  http_method = each.value.method
  rest_api_id = aws_api_gateway_rest_api.this.id

  status_code = "500"
}

resource "aws_api_gateway_integration_response" "pn_s3_200" {
  for_each   = local.pn_resources
  depends_on = [aws_api_gateway_integration.pn_s3_integration]

  resource_id = each.value.resource_id
  http_method = each.value.method
  status_code = aws_api_gateway_method_response.pn_s3_200[each.key].status_code
  rest_api_id = aws_api_gateway_rest_api.this.id

  response_parameters = {
    "method.response.header.Timestamp"      = "integration.response.header.Date"
    "method.response.header.Content-Length" = "integration.response.header.Content-Length"
    "method.response.header.Content-Type"   = "integration.response.header.Content-Type"
  }
}

resource "aws_api_gateway_integration_response" "pn_s3_403" {
  for_each   = local.pn_resources
  depends_on = [aws_api_gateway_integration.pn_s3_integration]

  resource_id = each.value.resource_id
  http_method = each.value.method
  status_code = aws_api_gateway_method_response.pn_s3_404[each.key].status_code
  rest_api_id = aws_api_gateway_rest_api.this.id

  selection_pattern = "403"

  response_templates = {
    "application/xml" = <<-EOF
      #set($inputRoot = $input.path('$'))
    EOF
  }
}

resource "aws_api_gateway_integration_response" "pn_s3_500" {
  for_each   = local.pn_resources
  depends_on = [aws_api_gateway_integration.pn_s3_integration]

  resource_id = each.value.resource_id
  http_method = each.value.method
  status_code = aws_api_gateway_method_response.pn_s3_500[each.key].status_code
  rest_api_id = aws_api_gateway_rest_api.this.id

  selection_pattern = "5\\d{2}"
}
