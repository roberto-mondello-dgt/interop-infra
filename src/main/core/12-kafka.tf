data "aws_subnets" "msk_interop_events" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  filter {
    name   = "vpc-id"
    values = [module.vpc_v2.vpc_id]
  }

  filter {
    name   = "cidr-block"
    values = toset(local.msk_interop_events_cidrs)
  }
}

resource "aws_security_group" "debezium_postgresql" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name        = format("msk-connect-debezium-pgsql-workers-%s", var.env)
  description = "MSK Connect Debezium PostgreSQL workers"

  vpc_id = module.vpc_v2.vpc_id

  # TODO: restrict
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "msk_interop_events" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  description = "MSK interop-events-${var.env}"
  name        = "MSK interop-events-${var.env}"

  vpc_id = module.vpc_v2.vpc_id

  ingress {
    description = "IAM clients inside AWS"
    from_port   = 9098
    to_port     = 9098
    protocol    = "tcp"
    security_groups = [
      aws_security_group.debezium_postgresql[0].id,
      module.eks_v2.cluster_primary_security_group_id,
      aws_security_group.bastion_host_v2.id,
      aws_security_group.vpn_clients.id,
      aws_security_group.github_runners_v2.id
    ]
  }

  # TODO: remove
  ingress {
    description = "Self"
    from_port   = 9098
    to_port     = 9098
    protocol    = "tcp"
    self        = true
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
  count = local.deploy_be_refactor_infra ? 1 : 0

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

locals {
  msk_iam_prefix = "arn:aws:kafka:${var.aws_region}:${data.aws_caller_identity.current.account_id}"

  interop_events_cluster_name = (local.deploy_be_refactor_infra ?
  aws_msk_serverless_cluster.interop_events[0].cluster_name : null)

  interop_events_cluster_uuid = (local.deploy_be_refactor_infra ?
  split("/", aws_msk_serverless_cluster.interop_events[0].arn)[2] : null)
  debezium_event_store_offsets_topic = "debezium.event-store.offsets"

  msk_topic_iam_prefix = (local.deploy_be_refactor_infra
    ? "${local.msk_iam_prefix}:topic/${local.interop_events_cluster_name}/${local.interop_events_cluster_uuid}"
  : null)
  msk_group_iam_prefix = (local.deploy_be_refactor_infra
    ? "${local.msk_iam_prefix}:group/${local.interop_events_cluster_name}/${local.interop_events_cluster_uuid}"
  : null)
}
