module "interop_selfcare_apigw_monitoring" {
  count = local.deploy_new_bff_apigw ? 0 : 1

  source = "./modules/apigw-monitoring"

  env           = var.env
  apigw_name    = module.interop_selfcare_apigw[0].apigw_name
  sns_topic_arn = aws_sns_topic.platform_alarms.arn

  alarm_5xx_threshold    = 1
  alarm_5xx_period       = 60
  alarm_5xx_eval_periods = 1
  alarm_5xx_datapoints   = 1
}
