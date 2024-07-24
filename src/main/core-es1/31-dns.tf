locals {
  # TODO: is there a better way? We need to fix "test" env name someday
  env_dns_name                   = replace(var.env, "test", "uat")
  interop_env_dns_domain         = var.env != "prod" ? format("%s.%s", local.env_dns_name, var.dns_interop_base_domain) : var.dns_interop_base_domain
  delegate_interop_dev_subdomain = var.env == "prod" && length(toset(var.dns_interop_dev_ns_records)) > 0
  delegate_interop_uat_subdomain = var.env == "prod" && length(toset(var.dns_interop_uat_ns_records)) > 0
  delegate_interop_qa_subdomain  = var.env == "prod" && length(toset(var.dns_interop_qa_ns_records)) > 0
  delegate_interop_att_subdomain = var.env == "prod" && length(toset(var.dns_interop_att_ns_records)) > 0
}

import {
  to = aws_route53_zone.interop_public
  id = "Z04170962VFG8V4TNAMPJ"
}

resource "aws_route53_zone" "interop_public" {
  name = local.interop_env_dns_domain
}

# import {
#   to = aws_route53_record.myrecord
#   id = "_dev.interop.pagopa.it_NS"
# }

resource "aws_route53_record" "interop_dev_delegation" {
  count = local.delegate_interop_dev_subdomain ? 1 : 0

  zone_id = aws_route53_zone.interop_public.zone_id
  name    = format("dev.%s", var.dns_interop_base_domain)
  type    = "NS"
  records = toset(var.dns_interop_dev_ns_records)
  ttl     = "300"
}


# import {
#   to = aws_route53_record.myrecord
#   id = "_uat.interop.pagopa.it_NS"
# }

resource "aws_route53_record" "interop_uat_delegation" {
  count = local.delegate_interop_uat_subdomain ? 1 : 0

  zone_id = aws_route53_zone.interop_public.zone_id
  name    = format("uat.%s", var.dns_interop_base_domain)
  type    = "NS"
  records = toset(var.dns_interop_uat_ns_records)
  ttl     = "300"
}

# import {
#     to = aws_route53_record.myrecord
#     id = "_qa.interop.pagopa.it_NS"
# }

resource "aws_route53_record" "interop_qa_delegation" {
  count = local.delegate_interop_qa_subdomain ? 1 : 0

  zone_id = aws_route53_zone.interop_public.zone_id
  name    = format("qa.%s", var.dns_interop_base_domain)
  type    = "NS"
  records = toset(var.dns_interop_qa_ns_records)
  ttl     = "300"
}

# import {
#     to = aws_route53_record.myrecord
#     id = "_att.interop.pagopa.it_NS"
# }

resource "aws_route53_record" "interop_att_delegation" {
  count = local.delegate_interop_att_subdomain ? 1 : 0

  zone_id = aws_route53_zone.interop_public.zone_id
  name    = format("att.%s", var.dns_interop_base_domain)
  type    = "NS"
  records = toset(var.dns_interop_att_ns_records)
  ttl     = "300"
}

import {
  to = aws_route53_record.probing_delegation[0]
  id = "Z04170962VFG8V4TNAMPJ_stato-eservice.dev.interop.pagopa.it_NS"
}

resource "aws_route53_record" "probing_delegation" {
  count = length(var.probing_domain_ns_records) > 0 ? 1 : 0

  zone_id = aws_route53_zone.interop_public.zone_id
  name    = format("stato-eservice.%s", local.interop_env_dns_domain)
  type    = "NS"
  records = toset(var.probing_domain_ns_records)
  ttl     = "300"
}

# import {
#     to = aws_route53_record.myrecord
#     id = "_signalhub.interop.pagopa.it_NS"
# }

resource "aws_route53_record" "signalhub_delegation" {
  count = var.env == "prod" && length(var.signalhub_domain_ns_records) > 0 ? 1 : 0

  zone_id = aws_route53_zone.interop_public.zone_id
  name    = format("signalhub.%s", local.interop_env_dns_domain)
  type    = "NS"
  records = toset(var.signalhub_domain_ns_records)
  ttl     = "300"
}

# import {
#     to = aws_route53_record.myrecord
#     id = "_tracing.interop.pagopa.it_NS"
# }

resource "aws_route53_record" "tracing_delegation" {
  count = var.env == "prod" && length(var.tracing_domain_ns_records) > 0 ? 1 : 0

  zone_id = aws_route53_zone.interop_public.zone_id
  name    = format("tracing.%s", local.interop_env_dns_domain)
  type    = "NS"
  records = toset(var.tracing_domain_ns_records)
  ttl     = "300"
}

# import {
#     to = aws_route53_record.interop_att_sandbox_delegation
#     id = "_eservices.att.interop.pagopa.it_NS"
# }

resource "aws_route53_record" "interop_att_sandbox_delegation" {
  count = var.env == "att" && length(var.dns_interop_att_sandbox_ns_records) > 0 ? 1 : 0

  zone_id = aws_route53_zone.interop_public.zone_id
  name    = format("eservices.%s", local.interop_env_dns_domain)
  type    = "NS"
  records = toset(var.dns_interop_att_sandbox_ns_records)
  ttl     = "300"
}
