# TODO: delete this file when DEMO platform is gone

locals {
  pdnd_domain_name    = "pdnd-interop.pagopa.it"
  pdnd_env_dns_domain = var.env != "prod" ? format("%s.%s", var.env, local.pdnd_domain_name) : local.pdnd_domain_name
}

import {
  for_each = var.env == "prod" ? [true] : [] # workaround to control import ENV

  to = aws_route53_zone.pdnd_public[0]
  id = "Z06242753OVTAAYMYB0RM"
}

resource "aws_route53_zone" "pdnd_public" {
  count = var.env == "prod" ? 1 : 0

  name = local.pdnd_env_dns_domain
}
