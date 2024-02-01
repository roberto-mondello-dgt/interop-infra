locals {
  openapi_abs_path = abspath(var.openapi_relative_path)
}

data "external" "openapi_integration" {
  program = concat(["python3", "${path.module}/scripts/openapi_append_parameters.py",
  "-i", local.openapi_abs_path])

  query = {
    privacy_notices_s3_bucket_arn             = "arn:aws:apigateway:${data.aws_region.current.name}:s3:path/${data.aws_s3_bucket.privacy_notices[0].bucket}"
    privacy_notices_role_arn                  = aws_iam_role.apigw_privacy_notices[0].arn
    m2m_interface_specification_s3_bucket_arn = "arn:aws:apigateway:${data.aws_region.current.name}:s3:path/${data.aws_s3_bucket.m2m_interface_specification[0].bucket}"
    m2m_interface_specification_role_arn      = aws_iam_role.apigw_m2m_interface_specification[0].arn
  }
}

resource "aws_api_gateway_rest_api" "this" {
  depends_on = [data.external.openapi_integration]

  name = (format("interop-%s-%s", var.api_name, var.env))

  body               = data.external.openapi_integration.result.computed_openapi_yaml
  put_rest_api_mode  = "overwrite"
  binary_media_types = ["multipart/form-data"]

  disable_execute_api_endpoint = true

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.this.body,
      var.vpc_link_id,
      var.nlb_domain_name,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_api_gateway_stage" "env" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id

  stage_name = var.env

  variables = {
    VpcLinkId        = var.vpc_link_id
    CustomDomainName = var.domain_name
  }

  dynamic "access_log_settings" {
    for_each = var.access_log_group_arn != null ? [var.access_log_group_arn] : []

    content {
      destination_arn = var.access_log_group_arn
      format = jsonencode({
        "apigwId"              = "$context.apiId"
        "requestId"            = "$context.requestId"
        "extendedRequestId"    = "$context.extendedRequestId"
        "sourceIp"             = "$context.identity.sourceIp"
        "requestTimeEpoch"     = "$context.requestTimeEpoch"
        "httpMethod"           = "$context.httpMethod"
        "requestPath"          = "$context.path"
        "resourcePath"         = "$context.resourcePath"
        "protocol"             = "$context.protocol"
        "userAgent"            = "$context.identity.userAgent"
        "status"               = "$context.status"
        "integrationLatencyMs" = "$context.integrationLatency"
        "integrationStatus"    = "$context.integrationStatus"
        "integrationError"     = "$context.integration.error"
        "responseLatencyMs"    = "$context.responseLatency"
        "responseLengthBytes"  = "$context.responseLength"
        "wafStatus"            = "$context.waf.status"
        "wafLatency"           = "$context.waf.latency"
        "wafError"             = "$context.waf.error"
        "xrayTraceId"          = "$context.xrayTraceId"
      })
    }
  }
}

resource "aws_api_gateway_method_settings" "all" {
  stage_name  = aws_api_gateway_stage.env.stage_name
  rest_api_id = aws_api_gateway_rest_api.this.id

  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "OFF"
  }
}

resource "aws_wafv2_web_acl_association" "this" {
  count = var.web_acl_arn != null ? 1 : 0

  resource_arn = aws_api_gateway_stage.env.arn
  web_acl_arn  = var.web_acl_arn
}
