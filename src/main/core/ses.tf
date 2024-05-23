module "reports_sender_identity" {
  count = var.env == "dev" ? 1 : 0

  source = "./modules/ses-identity"

  env                           = var.env
  ses_identity_name             = aws_route53_zone.interop_public.name
  hosted_zone_id                = aws_route53_zone.interop_public.zone_id
  create_alarms                 = true
  sns_topics_arn                = [aws_sns_topic.platform_alarms.arn]
  ses_reputation_sns_topics_arn = [aws_sns_topic.platform_alarms.arn, aws_sns_topic.ses_reputation[0].arn]
}

module "reports_sender_smtp_user" {
  count = var.env == "dev" ? 1 : 0

  source = "./modules/ses-smtp-user"

  env                            = var.env
  iam_username                   = "reports-sender"
  ses_identity_arn               = module.reports_sender_identity[0].ses_identity_arn
  ses_configuration_set_arn      = module.reports_sender_identity[0].ses_configuration_set_arn
  allowed_recipients_regex       = ["*@pagopa.it"]
  allowed_from_addresses_literal = [format("noreply@%s", module.reports_sender_identity[0].ses_identity_name)]
  allowed_from_display_names     = ["reports"]
  allowed_source_vpcs_id         = [module.vpc_v2.vpc_id]
}

resource "aws_sns_topic" "ses_reputation" {
  count = var.env == "dev" ? 1 : 0

  name = format("%s-ses-reputation-%s", var.short_name, var.env)
}

resource "aws_sns_topic_policy" "ses_reputation" {
  count = var.env == "dev" ? 1 : 0

  arn = aws_sns_topic.ses_reputation[0].arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudWatchAlarms"
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
        Action   = "sns:Publish"
        Resource = aws_sns_topic.ses_reputation[0].arn
        Condition = {
          ArnLike = {
            "aws:SourceArn" = "arn:aws:cloudwatch:${var.aws_region}:${data.aws_caller_identity.current.account_id}:alarm:*"
          }
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      },
      {
        Sid    = "AllowEventBridge"
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action   = "sns:Publish"
        Resource = aws_sns_topic.ses_reputation[0].arn
      }
    ]
  })
}