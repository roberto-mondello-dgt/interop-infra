data "aws_subnets" "vpn" {
  filter {
    name   = "vpc-id"
    values = [module.vpc_v2.vpc_id]
  }

  filter {
    name   = "cidr-block"
    values = toset(local.int_lbs_cidrs) # TODO: dedicated subnets?
  }
}

resource "aws_iam_saml_provider" "vpn" {
  count = var.env == "prod" ? 1 : 0

  name                   = format("interop-vpn-saml-%s", var.env)
  saml_metadata_document = file(var.vpn_saml_metadata_path)
}

resource "aws_cloudwatch_log_group" "vpn" {
  name = format("/aws/client-vpn/interop-vpn-%s/connections", var.env)

  retention_in_days = var.env == "prod" ? 90 : 30
  skip_destroy      = true
}

resource "aws_security_group" "vpn_clients" {
  description = format("SG for VPN clients of interop-vpn-%s", var.env)
  vpc_id      = module.vpc_v2.vpc_id

  egress {
    description = ""
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    # cidr_blocks      = ["0.0.0.0/0"]
    cidr_blocks      = [module.vpc_v2.vpc_cidr_block] # TODO: do we need access to the internet from VPN?
    ipv6_cidr_blocks = []
    security_groups  = []
  }
}

locals {
  vpc_ip_no_cidr = (split("/", module.vpc_v2.vpc_cidr_block))[0]
  vpc_dns_server = replace(local.vpc_ip_no_cidr, "/.0$/", ".2")
}

resource "aws_ec2_client_vpn_endpoint" "vpn" {
  description            = format("interop-vpn-%s", var.env)
  server_certificate_arn = var.env == "prod" ? aws_acm_certificate.vpn[0].arn : data.aws_acm_certificate.vpn[0].arn
  client_cidr_block      = "10.2.0.0/22" # avoid overlap with VPC and EKS' "cluster_service_ipv4_cidr"

  vpc_id             = module.vpc_v2.vpc_id
  security_group_ids = [aws_security_group.vpn_clients.id]

  split_tunnel = true
  dns_servers  = [local.vpc_dns_server]

  session_timeout_hours = 10

  dynamic "authentication_options" {
    for_each = var.env == "prod" ? [1] : []

    content {
      type              = "federated-authentication"
      saml_provider_arn = aws_iam_saml_provider.vpn[0].arn
    }
  }

  dynamic "authentication_options" {
    for_each = var.env != "prod" ? [1] : []

    content {
      type                       = "certificate-authentication"
      root_certificate_chain_arn = data.aws_acm_certificate.vpn[0].arn
    }
  }


  connection_log_options {
    enabled              = true
    cloudwatch_log_group = aws_cloudwatch_log_group.vpn.name
  }

  tags = {
    Name = format("interop-vpn-%s", var.env)
  }
}

locals {
  # single subnet is fine for dev/test
  vpn_subnets_ids = var.env == "prod" ? data.aws_subnets.vpn.ids : [data.aws_subnets.vpn.ids[0]]
}

resource "aws_ec2_client_vpn_network_association" "vpn_subnet" {
  for_each = toset(local.vpn_subnets_ids)

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  subnet_id              = each.value
}

resource "aws_ec2_client_vpn_authorization_rule" "vpc_only" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  target_network_cidr    = module.vpc_v2.vpc_cidr_block
  authorize_all_groups   = true
}
