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
      aws_security_group.vpn_clients.id
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

resource "aws_iam_role" "debezium_postgresql" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = format("interop-msk-connector-debezium-postgresql-%s", var.env)

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "kafkaconnect.amazonaws.com"
        }
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })

  inline_policy {
    name = "DebeziumConnector"

    policy = jsonencode({

      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "kafka-cluster:Connect",
            "kafka-cluster:CreateTopic",
            "kafka-cluster:DescribeCluster",
            "kafka-cluster:DescribeTopic",
            "kafka-cluster:ReadData",
            "kafka-cluster:WriteData"
          ]
          # TODO: restrict to specific topics
          Resource = [
            aws_msk_serverless_cluster.interop_events[0].arn,
            "${local.msk_topic_iam_prefix}/event-store.*",
          ]
        },
        {
          Effect = "Allow"
          Action = [
            "kafka-cluster:AlterGroup",
            "kafka-cluster:DescribeGroup",
            "kafka-cluster:CreateTopic",
            "kafka-cluster:DescribeTopic",
            "kafka-cluster:ReadData",
            "kafka-cluster:WriteData"
          ]
          Resource = [
            "${local.msk_topic_iam_prefix}/__amazon_msk_connect_*",
            "${local.msk_topic_iam_prefix}/${local.debezium_event_store_offsets_topic}",
            "${local.msk_group_iam_prefix}/__amazon_msk_connect_*",
            "${local.msk_group_iam_prefix}/connect-*",
          ]
        },
        {
          Effect = "Allow"
          Action = [
            "secretsmanager:DescribeSecret",
            "secretsmanager:GetResourcePolicy",
            "secretsmanager:GetSecretValue",
            "secretsmanager:ListSecretVersionIds"
          ]
          Resource = aws_secretsmanager_secret.debezium_credentials[0].arn
        }
      ]
    })
  }
}

resource "aws_mskconnect_worker_configuration" "secretsmanager_provider" {
  count = var.env == "dev" ? 1 : 0

  name = "secretsmanager-provider"

  properties_file_content = <<-EOT
    key.converter=org.apache.kafka.connect.storage.StringConverter
    key.converter.schemas.enable=false
    value.converter=org.apache.kafka.connect.json.JsonConverter
    value.converter.schemas.enable=false
    config.providers=secretsmanager
    config.providers.secretsmanager.class=com.amazonaws.kafka.config.providers.SecretsManagerConfigProvider
    config.providers.secretsmanager.param.region=${var.aws_region}
  EOT
}

resource "aws_mskconnect_worker_configuration" "debezium_postgresql_event_store" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "debezium-postgresql-event-store-${var.env}-4"

  properties_file_content = <<-EOT
    key.converter=org.apache.kafka.connect.json.JsonConverter
    key.converter.schemas.enable=false
    value.converter=org.apache.kafka.connect.json.JsonConverter
    value.converter.schemas.enable=false
    config.providers=secretsmanager
    config.providers.secretsmanager.class=com.amazonaws.kafka.config.providers.SecretsManagerConfigProvider
    config.providers.secretsmanager.param.region=${var.aws_region}
    offset.storage.topic=${local.debezium_event_store_offsets_topic}
  EOT
}

resource "aws_cloudwatch_log_group" "debezium_postgresql_event_store" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = format("/aws/msk-connect/workers/debezium-postgresql-event-store-%s", var.env)

  retention_in_days = var.env == "prod" ? 90 : 30
}

# msk_serverless_cluster TF resource doesn't expose the bootstrap servers attribute
data "external" "interop_events_bootstrap_servers" {
  count      = local.deploy_be_refactor_infra ? 1 : 0
  depends_on = [aws_msk_serverless_cluster.interop_events[0]]

  program = ["aws", "kafka", "get-bootstrap-brokers",
  "--cluster-arn", "${aws_msk_serverless_cluster.interop_events[0].arn}"]
}

resource "aws_mskconnect_custom_plugin" "debezium_postgresql" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name         = "debezium-postgresql-2-3-3-with-config-provider"
  content_type = "ZIP"

  location {
    s3 {
      bucket_arn = module.msk_custom_plugins_bucket[0].s3_bucket_arn
      file_key   = "debezium-postgresql-2-3-3-with-config-provider.zip"
    }
  }
}

locals {
  debezium_include_schema_prefix = var.env == "dev" ? "dev-refactor" : var.env
}

resource "aws_mskconnect_connector" "debezium_postgresql_event_store" {
  count      = local.deploy_be_refactor_infra ? 1 : 0
  depends_on = [data.external.interop_events_bootstrap_servers]

  name = "debezium-postgresql-2-3-3-event-store"

  kafkaconnect_version = "2.7.1"

  service_execution_role_arn = aws_iam_role.debezium_postgresql[0].arn

  plugin {
    custom_plugin {
      arn      = aws_mskconnect_custom_plugin.debezium_postgresql[0].arn
      revision = aws_mskconnect_custom_plugin.debezium_postgresql[0].latest_revision
    }
  }

  # TODO: refactor some of these fields using variables
  connector_configuration = {
    "connector.class"                                      = "io.debezium.connector.postgresql.PostgresConnector"
    "tasks.max"                                            = 1
    "database.hostname"                                    = module.persistence_management_aurora_cluster_v2.cluster_endpoint
    "database.port"                                        = module.persistence_management_aurora_cluster_v2.cluster_port
    "database.user"                                        = "$${secretsmanager:${aws_secretsmanager_secret.debezium_credentials[0].name}:username}"
    "database.password"                                    = "$${secretsmanager:${aws_secretsmanager_secret.debezium_credentials[0].name}:password}"
    "database.dbname"                                      = "persistence_management_refactor"
    "topic.prefix"                                         = "event-store"
    "plugin.name"                                          = "pgoutput"
    "binary.handling.mode"                                 = "hex"
    "slot.name"                                            = "debezium_event_store"
    "publication.name"                                     = "events_publication"
    "publication.autocreate.mode"                          = "disabled"
    "topic.creation.default.replication.factor"            = 3
    "topic.creation.default.partitions"                    = 3
    "topic.creation.default.cleanup.policy"                = "delete"
    "topic.creation.default.compression.type"              = "producer"
    "transforms"                                           = "PartitionRouting"
    "transforms.PartitionRouting.type"                     = "io.debezium.transforms.partitions.PartitionRouting"
    "transforms.PartitionRouting.partition.payload.fields" = "change.stream_id"
    "transforms.PartitionRouting.partition.topic.num"      = 3
    "table.include.list"                                   = "${local.debezium_include_schema_prefix}_.*\\.events"
  }

  worker_configuration {
    arn      = aws_mskconnect_worker_configuration.debezium_postgresql_event_store[0].arn
    revision = aws_mskconnect_worker_configuration.debezium_postgresql_event_store[0].latest_revision
  }

  capacity {
    provisioned_capacity {
      mcu_count    = 1
      worker_count = 1
    }
  }

  log_delivery {
    worker_log_delivery {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.debezium_postgresql_event_store[0].name
      }
    }
  }

  kafka_cluster {
    apache_kafka_cluster {
      bootstrap_servers = data.external.interop_events_bootstrap_servers[0].result.BootstrapBrokerStringSaslIam

      vpc {
        security_groups = [aws_security_group.debezium_postgresql[0].id]
        subnets         = data.aws_subnets.msk_interop_events[0].ids
      }
    }
  }

  kafka_cluster_client_authentication {
    authentication_type = "IAM"
  }

  kafka_cluster_encryption_in_transit {
    encryption_type = "TLS"
  }
}
