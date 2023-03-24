# TODO: delete this file when DEMO platform is gone

locals {
  pdnd_domain_name    = "pdnd-interop.pagopa.it"
  pdnd_env_dns_domain = var.env != "prod" ? format("%s.%s", var.env, local.pdnd_domain_name) : local.pdnd_domain_name

  pdnd_test_ns_records = [
    "ns-1149.awsdns-15.org.",
    "ns-218.awsdns-27.com.",
    "ns-1845.awsdns-38.co.uk.",
    "ns-523.awsdns-01.net.",
  ]
}

resource "aws_route53_zone" "pdnd_public" {
  count = var.env == "dev" ? 0 : 1

  name = local.pdnd_env_dns_domain
}

resource "aws_route53_record" "pdnd_uat_delegation" {
  count = var.env == "prod" ? 1 : 0

  zone_id = aws_route53_zone.pdnd_public[0].zone_id
  name    = format("test.%s", local.pdnd_domain_name)
  type    = "NS"
  records = toset(local.pdnd_test_ns_records)
  ttl     = "300"
}

