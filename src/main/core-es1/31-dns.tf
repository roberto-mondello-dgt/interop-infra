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
  for_each = var.env == "att" ? [true] : [] # workaround to control import ENV

  to = aws_route53_zone.interop_public
  id = "Z04685647FUY2PYWS8O0"
}

resource "aws_route53_zone" "interop_public" {
  name = local.interop_env_dns_domain
}

import {
  for_each = var.env == "prod" ? [true] : [] # workaround to control import ENV

  to = aws_route53_record.interop_dev_delegation[0]
  id = "_dev.interop.pagopa.it_NS"
}

resource "aws_route53_record" "interop_dev_delegation" {
  count = local.delegate_interop_dev_subdomain ? 1 : 0

  zone_id = aws_route53_zone.interop_public.zone_id
  name    = format("dev.%s", var.dns_interop_base_domain)
  type    = "NS"
  records = toset(var.dns_interop_dev_ns_records)
  ttl     = "300"
}


import {
  for_each = var.env == "prod" ? [true] : [] # workaround to control import ENV

  to = aws_route53_record.interop_uat_delegation[0]
  id = "_uat.interop.pagopa.it_NS"
}

resource "aws_route53_record" "interop_uat_delegation" {
  count = local.delegate_interop_uat_subdomain ? 1 : 0

  zone_id = aws_route53_zone.interop_public.zone_id
  name    = format("uat.%s", var.dns_interop_base_domain)
  type    = "NS"
  records = toset(var.dns_interop_uat_ns_records)
  ttl     = "300"
}

import {
  for_each = var.env == "prod" ? [true] : [] # workaround to control import ENV

  to = aws_route53_record.interop_qa_delegation[0]
  id = "_qa.interop.pagopa.it_NS"
}

resource "aws_route53_record" "interop_qa_delegation" {
  count = local.delegate_interop_qa_subdomain ? 1 : 0

  zone_id = aws_route53_zone.interop_public.zone_id
  name    = format("qa.%s", var.dns_interop_base_domain)
  type    = "NS"
  records = toset(var.dns_interop_qa_ns_records)
  ttl     = "300"
}

import {
  for_each = var.env == "prod" ? [true] : [] # workaround to control import ENV

  to = aws_route53_record.interop_att_delegation[0]
  id = "_att.interop.pagopa.it_NS"
}

resource "aws_route53_record" "interop_att_delegation" {
  count = local.delegate_interop_att_subdomain ? 1 : 0

  zone_id = aws_route53_zone.interop_public.zone_id
  name    = format("att.%s", var.dns_interop_base_domain)
  type    = "NS"
  records = toset(var.dns_interop_att_ns_records)
  ttl     = "300"
}

import {
  for_each = var.env == "test" ? [true] : [] # workaround to control import ENV

  to = aws_route53_record.probing_delegation[0]
  id = "Z047452525YHHCDUAYVCQ_stato-eservice.uat.interop.pagopa.it_NS"
}

resource "aws_route53_record" "probing_delegation" {
  count = length(var.probing_domain_ns_records) > 0 ? 1 : 0

  zone_id = aws_route53_zone.interop_public.zone_id
  name    = format("stato-eservice.%s", local.interop_env_dns_domain)
  type    = "NS"
  records = toset(var.probing_domain_ns_records)
  ttl     = "300"
}

import {
  for_each = var.env == "prod" ? [true] : [] # workaround to control import ENV

  to = aws_route53_record.signalhub_delegation[0]
  id = "_signalhub.interop.pagopa.it_NS"
}

resource "aws_route53_record" "signalhub_delegation" {
  count = var.env == "prod" && length(var.signalhub_domain_ns_records) > 0 ? 1 : 0

  zone_id = aws_route53_zone.interop_public.zone_id
  name    = format("signalhub.%s", local.interop_env_dns_domain)
  type    = "NS"
  records = toset(var.signalhub_domain_ns_records)
  ttl     = "300"
}

import {
  for_each = var.env == "prod" ? [true] : [] # workaround to control import ENV

  to = aws_route53_record.tracing_delegation[0]
  id = "_tracing.interop.pagopa.it_NS"
}

resource "aws_route53_record" "tracing_delegation" {
  count = var.env == "prod" && length(var.tracing_domain_ns_records) > 0 ? 1 : 0

  zone_id = aws_route53_zone.interop_public.zone_id
  name    = format("tracing.%s", local.interop_env_dns_domain)
  type    = "NS"
  records = toset(var.tracing_domain_ns_records)
  ttl     = "300"
}

import {
  for_each = var.env == "att" ? [true] : [] # workaround to control import ENV

  to = aws_route53_record.interop_att_sandbox_delegation[0]
  id = "Z04685647FUY2PYWS8O0_eservices.att.interop.pagopa.it_NS"
}

resource "aws_route53_record" "interop_att_sandbox_delegation" {
  count = var.env == "att" && length(var.dns_interop_att_sandbox_ns_records) > 0 ? 1 : 0

  zone_id = aws_route53_zone.interop_public.zone_id
  name    = format("eservices.%s", local.interop_env_dns_domain)
  type    = "NS"
  records = toset(var.dns_interop_att_sandbox_ns_records)
  ttl     = "300"
}
