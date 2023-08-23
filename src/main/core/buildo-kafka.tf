data "aws_subnets" "msk_interop_events" {
  count = var.env == "dev" ? 1 : 0

  filter {
    name   = "vpc-id"
    values = [module.vpc_v2.vpc_id]
  }

  filter {
    name   = "cidr-block"
    values = toset(local.msk_interop_events_cidrs)
  }
}

resource "aws_security_group" "msk_interop_events" {
  count = var.env == "dev" ? 1 : 0

  description = "MSK interop-events-${var.env}"
  name        = "MSK interop-events-${var.env}"
  vpc_id      = module.vpc_v2.vpc_id


  ingress {
    description = "IAM clients inside AWS"
    from_port   = 9098
    to_port     = 9098
    protocol    = "tcp"
    security_groups = [
      module.eks_v2.cluster_primary_security_group_id,
      aws_security_group.bastion_host_v2.id,
      aws_security_group.vpn_clients.id
    ]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_msk_serverless_cluster" "interop_events" {
  count = var.env == "dev" ? 1 : 0

  cluster_name = format("interop-events-%s", var.env)

  vpc_config {
    subnet_ids         = data.aws_subnets.msk_interop_events[0].ids
    security_group_ids = [aws_security_group.msk_interop_events[0].id]
  }

  client_authentication {
    sasl {
      iam {
        enabled = true
      }
    }
  }
}
