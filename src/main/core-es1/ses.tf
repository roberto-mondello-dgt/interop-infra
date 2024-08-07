module "reports_ses_identity" {
  source = "./modules/ses-identity"

  env                           = var.env
  ses_identity_name             = format("reports.%s", aws_route53_zone.interop_public.name)
  hosted_zone_id                = aws_route53_zone.interop_public.zone_id
  create_alarms                 = true
  sns_topics_arn                = [aws_sns_topic.platform_alarms.arn]
  ses_reputation_sns_topics_arn = [aws_sns_topic.platform_alarms.arn, aws_sns_topic.ses_reputation.arn]
}

module "notifiche_ses_identity" {
  source = "./modules/ses-identity"

  env                           = var.env
  ses_identity_name             = format("notifiche.%s", aws_route53_zone.interop_public.name)
  hosted_zone_id                = aws_route53_zone.interop_public.zone_id
  create_alarms                 = true
  sns_topics_arn                = [aws_sns_topic.platform_alarms.arn]
  ses_reputation_sns_topics_arn = [aws_sns_topic.platform_alarms.arn, aws_sns_topic.ses_reputation.arn]
}

# module "internal_ses_identity" {
#   count = var.env == "dev" ? 1 : 0
#
#   source = "./modules/ses-identity"
#
#   env                           = var.env
#   ses_identity_name             = format("internal.%s", aws_route53_zone.interop_public.name)
#   hosted_zone_id                = aws_route53_zone.interop_public.zone_id
#   create_alarms                 = true
#   sns_topics_arn                = [aws_sns_topic.platform_alarms.arn]
#   ses_reputation_sns_topics_arn = [aws_sns_topic.platform_alarms.arn, aws_sns_topic.ses_reputation.arn]
# }
