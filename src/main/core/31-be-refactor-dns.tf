resource "aws_route53_zone" "be_refactor_interop_public" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "refactor.${local.interop_env_dns_domain}"
}

resource "aws_route53_record" "be_refactor_interop_dev_delegation" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  zone_id = aws_route53_zone.interop_public.zone_id
  name    = aws_route53_zone.be_refactor_interop_public[0].name
  type    = "NS"
  records = toset(aws_route53_zone.be_refactor_interop_public[0].name_servers)
  ttl     = "300"
}
