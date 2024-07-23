resource "aws_cloudwatch_log_group" "apigw_access_logs" {
  name = format("amazon-apigateway-interop-access-logs-%s", var.env)

  retention_in_days = var.env == "prod" ? 90 : 30
  skip_destroy      = true
}

locals {
  deploy_new_bff_apigw = var.env == "dev" || var.env == "qa" ? true : false
}

# module "interop_auth_domain" {
#   source = "./modules/apigw-dns-domain"
#
#   env            = var.env
#   domain_name    = format("auth.%s", aws_route53_zone.interop_public.name)
#   hosted_zone_id = aws_route53_zone.interop_public.zone_id
# }
#
# module "interop_auth_apigw" {
#   source = "./modules/rest-apigw-openapi"
#
#   env                   = var.env
#   type                  = "generic"
#   api_name              = "auth-server"
#   openapi_relative_path = var.interop_auth_openapi_path
#   domain_name           = module.interop_auth_domain.apigw_custom_domain_name
#
#   vpc_link_id          = aws_api_gateway_vpc_link.integration.id
#   service_prefix       = "authorization-server"
#   web_acl_arn          = aws_wafv2_web_acl.interop.arn
#   access_log_group_arn = aws_cloudwatch_log_group.apigw_access_logs.arn
#
#   create_cloudwatch_alarm     = true
#   create_cloudwatch_dashboard = true
#   sns_topic_arn               = aws_sns_topic.platform_alarms.arn
#   alarm_5xx_threshold         = 1
#   alarm_5xx_period            = 60
#   alarm_5xx_eval_periods      = 1
#   alarm_5xx_datapoints        = 1
# }
#
# module "interop_selfcare_domain" {
#   source = "./modules/apigw-dns-domain"
#
#   env            = var.env
#   domain_name    = format("selfcare.%s", aws_route53_zone.interop_public.name)
#   hosted_zone_id = aws_route53_zone.interop_public.zone_id
# }
#
#
# module "interop_selfcare_apigw" {
#   count = local.deploy_new_bff_apigw ? 0 : 1
#
#   source = "./modules/rest-apigw-proxy"
#
#   env         = var.env
#   api_name    = "selfcare"
#   domain_name = module.interop_selfcare_domain.apigw_custom_domain_name
#
#   is_bff                      = true
#   privacy_notices_bucket_name = module.privacy_notices_content_bucket.s3_bucket_id
#
#   vpc_link_id          = aws_api_gateway_vpc_link.integration.id
#   nlb_domain_name      = module.nlb_v2.lb_dns_name
#   web_acl_arn          = aws_wafv2_web_acl.interop.arn
#   access_log_group_arn = aws_cloudwatch_log_group.apigw_access_logs.arn
# }
#
# module "interop_selfcare_1dot0_apigw" {
#   count = local.deploy_new_bff_apigw ? 1 : 0
#
#   source = "./modules/rest-apigw-openapi"
#
#   env                   = var.env
#   type                  = "bff"
#   api_name              = "selfcare"
#   api_version           = "1.0"
#   openapi_relative_path = var.interop_bff_openapi_path
#   domain_name           = module.interop_selfcare_domain.apigw_custom_domain_name
#
#   vpc_link_id          = aws_api_gateway_vpc_link.integration.id
#   service_prefix       = "backend-for-frontend"
#   web_acl_arn          = aws_wafv2_web_acl.interop.arn
#   access_log_group_arn = aws_cloudwatch_log_group.apigw_access_logs.arn
#
#   create_cloudwatch_alarm     = true
#   create_cloudwatch_dashboard = true
#   sns_topic_arn               = aws_sns_topic.platform_alarms.arn
#   alarm_5xx_threshold         = 1
#   alarm_5xx_period            = 60
#   alarm_5xx_eval_periods      = 1
#   alarm_5xx_datapoints        = 1
# }
#
# module "interop_selfcare_0dot0_apigw" {
#   count = local.deploy_new_bff_apigw ? 1 : 0
#
#   source = "./modules/rest-apigw-openapi"
#
#   env                   = var.env
#   type                  = "bff"
#   api_name              = "selfcare"
#   api_version           = "0.0"
#   openapi_relative_path = var.interop_bff_openapi_path
#   domain_name           = module.interop_selfcare_domain.apigw_custom_domain_name
#
#   vpc_link_id          = aws_api_gateway_vpc_link.integration.id
#   service_prefix       = "backend-for-frontend"
#   web_acl_arn          = aws_wafv2_web_acl.interop.arn
#   access_log_group_arn = aws_cloudwatch_log_group.apigw_access_logs.arn
#
#   create_cloudwatch_alarm     = true
#   create_cloudwatch_dashboard = true
#   sns_topic_arn               = aws_sns_topic.platform_alarms.arn
#   alarm_5xx_threshold         = 1
#   alarm_5xx_period            = 60
#   alarm_5xx_eval_periods      = 1
#   alarm_5xx_datapoints        = 1
# }
#
# module "interop_frontend_assets_apigw" {
#   count = local.deploy_new_bff_apigw ? 1 : 0
#
#   source = "./modules/apigw-frontend-assets"
#
#   env                   = var.env
#   api_name              = "frontend-assets"
#   openapi_relative_path = var.interop_frontend_assets_openapi_path
#   domain_name           = module.interop_selfcare_domain.apigw_custom_domain_name
#
#   privacy_notices_bucket_name            = module.privacy_notices_content_bucket.s3_bucket_id
#   frontend_additional_assets_bucket_name = module.frontend_additional_assets_bucket[0].s3_bucket_id
#
#   vpc_link_id          = aws_api_gateway_vpc_link.integration.id
#   web_acl_arn          = aws_wafv2_web_acl.interop.arn
#   access_log_group_arn = aws_cloudwatch_log_group.apigw_access_logs.arn
#
#   create_cloudwatch_alarm     = true
#   create_cloudwatch_dashboard = true
#   sns_topic_arn               = aws_sns_topic.platform_alarms.arn
#   alarm_5xx_threshold         = 1
#   alarm_5xx_period            = 60
#   alarm_5xx_eval_periods      = 1
#   alarm_5xx_datapoints        = 1
# }
#
# module "interop_api_domain" {
#   source = "./modules/apigw-dns-domain"
#
#   env            = var.env
#   domain_name    = format("api.%s", aws_route53_zone.interop_public.name)
#   hosted_zone_id = aws_route53_zone.interop_public.zone_id
# }
#
# module "interop_api_1dot0_apigw" {
#   source = "./modules/rest-apigw-openapi"
#
#   env                   = var.env
#   type                  = "generic"
#   api_name              = "api"
#   api_version           = "1.0"
#   openapi_relative_path = var.interop_api_openapi_path
#   domain_name           = module.interop_api_domain.apigw_custom_domain_name
#
#   vpc_link_id          = aws_api_gateway_vpc_link.integration.id
#   service_prefix       = "api-gateway"
#   web_acl_arn          = aws_wafv2_web_acl.interop.arn
#   access_log_group_arn = aws_cloudwatch_log_group.apigw_access_logs.arn
#
#   create_cloudwatch_alarm     = true
#   create_cloudwatch_dashboard = true
#   sns_topic_arn               = aws_sns_topic.platform_alarms.arn
#   alarm_5xx_threshold         = 1
#   alarm_5xx_period            = 60
#   alarm_5xx_eval_periods      = 1
#   alarm_5xx_datapoints        = 1
# }
#
# module "interop_api_0dot0_apigw" {
#   count = var.env == "dev" ? 1 : 0
#
#   source = "./modules/rest-apigw-openapi"
#
#   env                   = var.env
#   type                  = "generic"
#   api_name              = "api"
#   api_version           = "0.0"
#   openapi_relative_path = var.interop_api_openapi_path
#   domain_name           = module.interop_api_domain.apigw_custom_domain_name
#
#   vpc_link_id          = aws_api_gateway_vpc_link.integration.id
#   service_prefix       = "api-gateway"
#   web_acl_arn          = aws_wafv2_web_acl.interop.arn
#   access_log_group_arn = aws_cloudwatch_log_group.apigw_access_logs.arn
#
#   create_cloudwatch_alarm     = true
#   create_cloudwatch_dashboard = true
#   sns_topic_arn               = aws_sns_topic.platform_alarms.arn
#   alarm_5xx_threshold         = 1
#   alarm_5xx_period            = 60
#   alarm_5xx_eval_periods      = 1
#   alarm_5xx_datapoints        = 1
# }
