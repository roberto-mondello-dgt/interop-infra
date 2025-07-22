resource "aws_route53_zone" "api_gov_public" {
  count = var.dns_api_gov_domain != null ? 1 : 0

  name = var.dns_api_gov_domain
}
