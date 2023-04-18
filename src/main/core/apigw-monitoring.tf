module "interop_auth_apigw_monitoring" {
  source     = "./modules/apigw-monitoring"
  depends_on = [module.interop_auth_apigw]

  env           = var.env
  apigw_name    = module.interop_auth_apigw.apigw_name
  sns_topic_arn = aws_sns_topic.platform_alarms.arn

  alarm_5xx_threshold    = 1
  alarm_5xx_period       = 60
  alarm_5xx_eval_periods = 1
  alarm_5xx_datapoints   = 1
}

module "interop_selfcare_apigw_monitoring" {
  source     = "./modules/apigw-monitoring"
  depends_on = [module.interop_selfcare_apigw]

  env           = var.env
  apigw_name    = module.interop_selfcare_apigw.apigw_name
  sns_topic_arn = aws_sns_topic.platform_alarms.arn

  alarm_5xx_threshold    = 1
  alarm_5xx_period       = 60
  alarm_5xx_eval_periods = 1
  alarm_5xx_datapoints   = 1
}

module "interop_api_1dot0_apigw_monitoring" {
  source     = "./modules/apigw-monitoring"
  depends_on = [module.interop_api_1dot0_apigw]

  env           = var.env
  apigw_name    = module.interop_api_1dot0_apigw.apigw_name
  sns_topic_arn = aws_sns_topic.platform_alarms.arn

  alarm_5xx_threshold    = 1
  alarm_5xx_period       = 60
  alarm_5xx_eval_periods = 1
  alarm_5xx_datapoints   = 1
}

module "interop_api_0dot0_apigw_monitoring" {
  count = var.env == "dev" ? 1 : 0

  source     = "./modules/apigw-monitoring"
  depends_on = [module.interop_api_0dot0_apigw[0]]

  env           = var.env
  apigw_name    = module.interop_api_0dot0_apigw[0].apigw_name
  sns_topic_arn = aws_sns_topic.platform_alarms.arn

  alarm_5xx_threshold    = 1
  alarm_5xx_period       = 60
  alarm_5xx_eval_periods = 1
  alarm_5xx_datapoints   = 1
}
