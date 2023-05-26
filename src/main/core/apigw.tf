resource "aws_cloudwatch_log_group" "apigw_access_logs" {
  name = format("amazon-apigateway-interop-access-logs-%s", var.env)

  retention_in_days = var.env == "prod" ? 90 : 30
  skip_destroy      = true
}

module "interop_auth_domain" {
  source = "./modules/apigw-dns-domain"

  env            = var.env
  domain_name    = format("auth.%s", aws_route53_zone.interop_public.name)
  hosted_zone_id = aws_route53_zone.interop_public.zone_id
}

module "interop_auth_apigw" {
  source = "./modules/rest-apigw-openapi"

  env                   = var.env
  api_name              = "auth-server"
  openapi_relative_path = var.interop_auth_openapi_path
  domain_name           = module.interop_auth_domain.apigw_custom_domain_name

  vpc_link_id          = aws_api_gateway_vpc_link.integration.id
  nlb_domain_name      = module.nlb_v2.lb_dns_name
  service_prefix       = "authorization-server"
  web_acl_arn          = aws_wafv2_web_acl.interop.arn
  access_log_group_arn = aws_cloudwatch_log_group.apigw_access_logs.arn
}

module "interop_selfcare_domain" {
  source = "./modules/apigw-dns-domain"

  env            = var.env
  domain_name    = format("selfcare.%s", aws_route53_zone.interop_public.name)
  hosted_zone_id = aws_route53_zone.interop_public.zone_id
}

# TODO: convert to OpenAPI
module "interop_selfcare_apigw" {
  source = "./modules/rest-apigw-proxy"

  env                   = var.env
  api_name              = "selfcare"
  domain_name           = module.interop_selfcare_domain.apigw_custom_domain_name
  frontend_redirect_uri = "/ui"

  vpc_link_id          = aws_api_gateway_vpc_link.integration.id
  nlb_domain_name      = module.nlb_v2.lb_dns_name
  web_acl_arn          = aws_wafv2_web_acl.interop.arn
  access_log_group_arn = aws_cloudwatch_log_group.apigw_access_logs.arn
}

module "interop_api_domain" {
  source = "./modules/apigw-dns-domain"

  env            = var.env
  domain_name    = format("api.%s", aws_route53_zone.interop_public.name)
  hosted_zone_id = aws_route53_zone.interop_public.zone_id
}

module "interop_api_1dot0_apigw" {
  source = "./modules/rest-apigw-openapi"

  env                   = var.env
  api_name              = "api"
  api_version           = "1.0"
  openapi_relative_path = var.interop_api_openapi_path
  domain_name           = module.interop_api_domain.apigw_custom_domain_name

  vpc_link_id          = aws_api_gateway_vpc_link.integration.id
  nlb_domain_name      = module.nlb_v2.lb_dns_name
  service_prefix       = "api-gateway"
  web_acl_arn          = aws_wafv2_web_acl.interop.arn
  access_log_group_arn = aws_cloudwatch_log_group.apigw_access_logs.arn
}

module "interop_api_0dot0_apigw" {
  count = var.env == "dev" ? 1 : 0

  source = "./modules/rest-apigw-openapi"

  env                   = var.env
  api_name              = "api"
  api_version           = "0.0"
  openapi_relative_path = var.interop_api_openapi_path
  domain_name           = module.interop_api_domain.apigw_custom_domain_name

  vpc_link_id          = aws_api_gateway_vpc_link.integration.id
  nlb_domain_name      = module.nlb_v2.lb_dns_name
  service_prefix       = "api-gateway"
  web_acl_arn          = aws_wafv2_web_acl.interop.arn
  access_log_group_arn = aws_cloudwatch_log_group.apigw_access_logs.arn
}
