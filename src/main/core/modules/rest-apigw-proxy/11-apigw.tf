resource "aws_api_gateway_rest_api" "this" {
  name = (var.api_version != null ? format("interop-%s-%s-%s", var.api_name, var.api_version, var.env)
  : format("interop-%s-%s", var.api_name, var.env))

  binary_media_types = ["multipart/form-data"]

  disable_execute_api_endpoint = true

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "proxy" {
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.this.id

  path_part = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy_any" {
  resource_id = aws_api_gateway_resource.proxy.id
  rest_api_id = aws_api_gateway_rest_api.this.id

  authorization = "NONE"
  http_method   = "ANY"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "proxy" {
  http_method = aws_api_gateway_method.proxy_any.http_method
  resource_id = aws_api_gateway_resource.proxy.id
  rest_api_id = aws_api_gateway_rest_api.this.id

  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link_id
  uri                     = format("http://%s/{proxy}", var.nlb_domain_name)

  passthrough_behavior = "WHEN_NO_MATCH"
  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_method" "frontend_redirect" {
  count = var.frontend_redirect_uri != null ? 1 : 0

  resource_id = aws_api_gateway_rest_api.this.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.this.id

  authorization = "NONE"
  http_method   = "GET"
}

resource "aws_api_gateway_integration" "frontend_redirect" {
  count = var.frontend_redirect_uri != null ? 1 : 0

  http_method = aws_api_gateway_method.frontend_redirect[0].http_method
  resource_id = aws_api_gateway_rest_api.this.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.this.id

  type = "MOCK"

  passthrough_behavior = "WHEN_NO_TEMPLATES"
  request_templates = {
    "application/json" = jsonencode({ statusCode = 301 })
  }
}

resource "aws_api_gateway_method_response" "frontend_redirect" {
  count = var.frontend_redirect_uri != null ? 1 : 0

  resource_id = aws_api_gateway_rest_api.this.root_resource_id
  http_method = aws_api_gateway_method.frontend_redirect[0].http_method
  rest_api_id = aws_api_gateway_rest_api.this.id

  status_code = "301"
  response_parameters = {
    "method.response.header.Location" = true
  }
}

resource "aws_api_gateway_integration_response" "frontend_redirect" {
  count = var.frontend_redirect_uri != null ? 1 : 0

  resource_id = aws_api_gateway_rest_api.this.root_resource_id
  http_method = aws_api_gateway_method.frontend_redirect[0].http_method
  rest_api_id = aws_api_gateway_rest_api.this.id

  status_code       = aws_api_gateway_method_response.frontend_redirect[0].status_code
  selection_pattern = "301"
  response_parameters = {
    "method.response.header.Location" = format("'%s'", var.frontend_redirect_uri)
  }
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  # TODO: this is temporary, the apigw will be converted to openapi
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.this.id
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

  dynamic "access_log_settings" {
    for_each = var.access_log_group_arn != null ? [var.access_log_group_arn] : []

    content {
      destination_arn = var.access_log_group_arn
      format = jsonencode({
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
        "responseLatencyMs"    = "$context.responseLatency"
        "wafStatus"            = "$context.waf.status"
        "wafError"             = "$context.waf.error"
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
