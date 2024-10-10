resource "aws_route53_record" "landing_www" {
  provider = aws.us_east_1

  name    = format("www.%s", var.interop_landing_domain_name)
  type    = "A"
  zone_id = aws_route53_zone.interop_public.zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_cloudfront_distribution.landing.domain_name
    zone_id                = "Z2FDTNDATAQYW2" # fixed value for CloudFront distributions
  }
}

resource "aws_route53_record" "landing_base" {
  provider = aws.us_east_1

  name    = var.interop_landing_domain_name
  type    = "A"
  zone_id = aws_route53_zone.interop_public.zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_cloudfront_distribution.landing.domain_name
    zone_id                = "Z2FDTNDATAQYW2" # fixed value for CloudFront distributions
  }
}

import {
  for_each = var.env == "prod" ? [true] : [] # workaround to control import ENV

  to = aws_acm_certificate.landing
  id = "arn:aws:acm:us-east-1:697818730278:certificate/6aa480e4-6eed-441e-8dcb-062c4f099c51"
}

resource "aws_acm_certificate" "landing" {
  provider = aws.us_east_1

  domain_name       = format("www.%s", var.interop_landing_domain_name)
  validation_method = "DNS"

  subject_alternative_names = [var.interop_landing_domain_name]

  lifecycle {
    create_before_destroy = true
  }
}

import {
  for_each = var.env == "prod" ? [true] : [] # workaround to control import ENV

  to = aws_route53_record.landing_cert_validation["www.interop.pagopa.it"]
  id = "Z100714238OQISA97RBZW__1174abc8a6118a4d3470b2ba599ba06e.www.interop.pagopa.it._CNAME"
}

import {
  for_each = var.env == "prod" ? [true] : [] # workaround to control import ENV

  to = aws_route53_record.landing_cert_validation["interop.pagopa.it"]
  id = "Z100714238OQISA97RBZW__ab5d299d631093fb4403913246d9e0af.interop.pagopa.it._CNAME"
}

resource "aws_route53_record" "landing_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.landing.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  name    = each.value.name
  records = [each.value.record]
  type    = each.value.type
  zone_id = aws_route53_zone.interop_public.zone_id
  ttl     = 300
}

resource "aws_acm_certificate_validation" "landing" {
  provider = aws.us_east_1

  certificate_arn         = aws_acm_certificate.landing.arn
  validation_record_fqdns = [for record in aws_route53_record.landing_cert_validation : record.fqdn]
}
