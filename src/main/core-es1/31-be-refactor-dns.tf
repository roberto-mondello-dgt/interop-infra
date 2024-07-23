import {
  to = aws_route53_zone.be_refactor_interop_public[0]
  id = "Z04274813D5EX81VLQ2T9"
}

resource "aws_route53_zone" "be_refactor_interop_public" {
  count = var.env == "dev" ? 1 : 0

  name = "refactor.${local.interop_env_dns_domain}"
}

import {
  to = aws_route53_record.be_refactor_interop_dev_delegation[0]
  id = "Z04170962VFG8V4TNAMPJ_refactor.dev.interop.pagopa.it_NS"
}

resource "aws_route53_record" "be_refactor_interop_dev_delegation" {
  count = var.env == "dev" ? 1 : 0

  zone_id = aws_route53_zone.interop_public.zone_id
  name    = aws_route53_zone.be_refactor_interop_public[0].name
  type    = "NS"
  records = toset(aws_route53_zone.be_refactor_interop_public[0].name_servers)
  ttl     = "300"
}
