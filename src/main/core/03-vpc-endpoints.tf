data "aws_subnets" "vpce" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  filter {
    name   = "vpc-id"
    values = [module.vpc_v2.vpc_id]
  }

  filter {
    name   = "cidr-block"
    values = toset(local.vpce_cidrs)
  }
}

# TODO: restrict?
resource "aws_security_group" "vpce_common" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name        = format("vpce-common-%s", var.env)
  description = "Common SG across all VPC Endpoints"

  vpc_id = module.vpc_v2.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.vpc_v2.vpc_cidr_block]
  }
}

module "vpce" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.1.2"

  vpc_id = module.vpc_v2.vpc_id
  # Create one VPCE per AZ only in prod
  subnet_ids         = var.env == "prod" ? data.aws_subnets.vpce[0].ids : [data.aws_subnets.vpce[0].ids[0]]
  security_group_ids = [aws_security_group.vpce_common[0].id]

  endpoints = {
    secrets_manager = {
      service_name        = "com.amazonaws.${var.aws_region}.secretsmanager"
      service_type        = "Interface"
      private_dns_enabled = true

      tags = { Name = "secrets-manager" }
    }
  }
}

