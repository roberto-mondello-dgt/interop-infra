resource "aws_sesv2_configuration_set" "standard" {
  count = var.env == "dev" ? 1 : 0

  configuration_set_name = format("standard-config-%s", var.env)

  delivery_options {
    tls_policy = "REQUIRE"
  }

  reputation_options {
    reputation_metrics_enabled = true
  }
}

resource "aws_sesv2_configuration_set_event_destination" "standard" {
  count = var.env == "dev" ? 1 : 0

  configuration_set_name = aws_sesv2_configuration_set.standard[0].configuration_set_name
  event_destination_name = format("standard-config-cloudwatch-%s", var.env)

  event_destination {
    cloud_watch_destination {
      dimension_configuration {
        default_dimension_value = aws_route53_zone.interop_public.name
        dimension_name          = "ses:from-domain"
        dimension_value_source  = "MESSAGE_TAG"
      }
    }

    enabled              = true
    matching_event_types = ["BOUNCE", "COMPLAINT", "REJECT", "SEND"]
  }
}

resource "aws_sesv2_email_identity" "interop" {
  count = var.env == "dev" ? 1 : 0

  email_identity         = aws_route53_zone.interop_public.name
  configuration_set_name = aws_sesv2_configuration_set.standard[0].configuration_set_name

  dkim_signing_attributes {
    next_signing_key_length = "RSA_2048_BIT"
  }
}

resource "aws_route53_record" "interop_dkim" {
  count = var.env == "dev" ? 3 : 0

  zone_id = aws_route53_zone.interop_public.zone_id
  name    = format("%s._domainkey.%s", aws_sesv2_email_identity.interop[0].dkim_signing_attributes[0].tokens[count.index], aws_sesv2_email_identity.interop[0].email_identity)
  type    = "CNAME"
  ttl     = "600"
  records = ["${aws_sesv2_email_identity.interop[0].dkim_signing_attributes[0].tokens[count.index]}.dkim.amazonses.com"]
}

resource "aws_sesv2_email_identity_mail_from_attributes" "interop" {
  count = var.env == "dev" ? 1 : 0

  email_identity = aws_sesv2_email_identity.interop[0].email_identity

  behavior_on_mx_failure = "REJECT_MESSAGE"
  mail_from_domain       = "mail.${aws_sesv2_email_identity.interop[0].email_identity}"
}

resource "aws_route53_record" "interop_spf" {
  count = var.env == "dev" ? 1 : 0

  zone_id = aws_route53_zone.interop_public.zone_id
  name    = aws_sesv2_email_identity_mail_from_attributes.interop[0].mail_from_domain
  type    = "TXT"
  ttl     = "600"
  records = ["v=spf1 include:amazonses.com -all"]
}

resource "aws_route53_record" "interop_mx" {
  count = var.env == "dev" ? 1 : 0

  zone_id = aws_route53_zone.interop_public.zone_id
  name    = aws_sesv2_email_identity_mail_from_attributes.interop[0].mail_from_domain
  type    = "MX"
  ttl     = "600"
  records = ["10 feedback-smtp.${var.aws_region}.amazonses.com"]
}

resource "aws_iam_user" "reports_sender" {
  count = var.env == "dev" ? 1 : 0

  name = format("interop-reports-sender-%s", var.env)
}

resource "aws_iam_policy" "reports_sender" {
  count = var.env == "dev" ? 1 : 0

  name = format("interop-reports-sender-%s-policy", var.env)

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow",
      Action = [
        "ses:SendRawEmail"
      ]
      Resource = [
        aws_sesv2_configuration_set.standard[0].arn,
        aws_sesv2_email_identity.interop[0].arn
      ],
      Condition = {
        "ForAllValues:StringLike" = {
          "ses:Recipients" = ["*@pagopa.it"]
        },
        StringEquals = {
          "ses:FromAddress"     = format("noreply@%s", aws_sesv2_email_identity.interop[0].email_identity),
          "ses:FromDisplayName" = "reports"
        },
        "ForAllValues:IpAddress" : {
          "aws:SourceIp" : [module.vpc_v2.vpc_cidr_block]
        }
      }
    }]
  })
}

resource "aws_iam_user_policy_attachment" "reports_sender" {
  count = var.env == "dev" ? 1 : 0

  user       = aws_iam_user.reports_sender[0].name
  policy_arn = aws_iam_policy.reports_sender[0].arn
}

resource "aws_cloudwatch_metric_alarm" "reports_sender_reject" {
  count = var.env == "dev" ? 1 : 0

  alarm_name          = format("reports-sender-%s-reject-alarm", var.env)
  comparison_operator = "GreaterThanOrEqualToThreshold"
  metric_name         = "Reject"
  namespace           = "AWS/SES"
  period              = "60"
  evaluation_periods  = "5"
  threshold           = "1"
  datapoints_to_alarm = "1"
  statistic           = "Sum"
  alarm_description   = "This metric checks for reject rate"
  alarm_actions       = [aws_sns_topic.platform_alarms.arn]
  dimensions = {
    Identity = aws_sesv2_email_identity.interop[0].email_identity
  }
}

resource "aws_cloudwatch_metric_alarm" "reports_sender_bounce" {
  count = var.env == "dev" ? 1 : 0

  alarm_name          = format("reports-sender-%s-bounce-alarm", var.env)
  comparison_operator = "GreaterThanThreshold"
  metric_name         = "Reputation.BounceRate"
  namespace           = "AWS/SES"
  period              = "60"
  evaluation_periods  = "5"
  threshold           = "0"
  datapoints_to_alarm = "1"
  statistic           = "Average"
  alarm_description   = "This metric checks for bounce rate"
  alarm_actions       = [aws_sns_topic.platform_alarms.arn, aws_sns_topic.ses_reputation[0].arn]
  dimensions = {
    Identity = aws_sesv2_email_identity.interop[0].email_identity
  }
}

resource "aws_cloudwatch_metric_alarm" "reports_sender_complaint" {
  count = var.env == "dev" ? 1 : 0

  alarm_name          = format("reports-sender-%s-complaint-alarm", var.env)
  comparison_operator = "GreaterThanThreshold"
  metric_name         = "Reputation.ComplaintRate"
  namespace           = "AWS/SES"
  period              = "60"
  evaluation_periods  = "5"
  threshold           = "0"
  datapoints_to_alarm = "1"
  statistic           = "Average"
  alarm_description   = "This metric checks for complaint rate"
  alarm_actions       = [aws_sns_topic.platform_alarms.arn, aws_sns_topic.ses_reputation[0].arn]
  dimensions = {
    Identity = aws_sesv2_email_identity.interop[0].email_identity
  }
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
