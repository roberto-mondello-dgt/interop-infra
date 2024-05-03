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

resource "aws_iam_policy" "be_refactor_debezium_postgresql" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "DebeziumPostgresqlPolicy"

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
          "kafka-cluster:DescribeTopicDynamicConfiguration",
          "kafka-cluster:AlterTopicDynamicConfiguration",
          "kafka-cluster:AlterGroup",
          "kafka-cluster:DescribeGroup",
          "kafka-cluster:ReadData",
          "kafka-cluster:WriteData"
        ]

        Resource = [
          aws_msk_serverless_cluster.interop_events[0].arn,
          "${local.msk_topic_iam_prefix}/__debezium.*",
          "${local.msk_topic_iam_prefix}/experimental.*",
          "${local.msk_topic_iam_prefix}/event-store.*",
          "${local.msk_group_iam_prefix}/debezium.*",
          "${local.msk_group_iam_prefix}/experimental.*",
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

resource "aws_iam_policy" "be_refactor_catalog_process" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "InteropBeCatalogProcessRefactorPolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = format("%s/*", var.env == "dev" ? module.be_refactor_application_documents_bucket[0].s3_bucket_arn : module.application_documents_bucket.s3_bucket_arn)
      }
    ]
  })
}

# TODO: refactor Kafka policies to be reusable
resource "aws_iam_policy" "be_refactor_catalog_readmodel_writer" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "InteropBeCatalogReadModelWriter"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kafka-cluster:AlterGroup",
          "kafka-cluster:Connect",
          "kafka-cluster:DescribeGroup",
          "kafka-cluster:DescribeTopic",
          "kafka-cluster:ReadData"
        ]

        Resource = [
          aws_msk_serverless_cluster.interop_events[0].arn,
          "${local.msk_topic_iam_prefix}/event-store.*_catalog.events",
          "${local.msk_group_iam_prefix}/*-catalog-readmodel-writer"
        ]
      }
    ]
  })
}

# TODO: refactor Kafka policies to be reusable
resource "aws_iam_policy" "be_refactor_attribute_registry_readmodel_writer" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "InteropBeAttributeRegistryReadModelWriter"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kafka-cluster:AlterGroup",
          "kafka-cluster:Connect",
          "kafka-cluster:DescribeGroup",
          "kafka-cluster:DescribeTopic",
          "kafka-cluster:ReadData"
        ]

        Resource = [
          aws_msk_serverless_cluster.interop_events[0].arn,
          "${local.msk_topic_iam_prefix}/event-store.*_attribute_registry.events",
          "${local.msk_group_iam_prefix}/*-attribute-registry-readmodel-writer"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "be_refactor_agreement_process" {
  count = var.env == "dev" ? 1 : 0

  name = "InteropBeAgreementProcessRefactorPolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = format("%s/*", module.be_refactor_application_documents_bucket[0].s3_bucket_arn)
      },
      {
        Effect   = "Allow"
        Action   = "sqs:SendMessage"
        Resource = module.be_refactor_persistence_events_queue[0].queue_arn
      },
      {
        Effect   = "Allow"
        Action   = "sqs:SendMessage"
        Resource = module.be_refactor_certified_mail_queue[0].queue_arn
      },
    ]
  })
}

resource "aws_iam_policy" "be_refactor_agreement_readmodel_writer" {
  count = var.env == "dev" ? 1 : 0

  name = "InteropBeAgreementReadModelWriter"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kafka-cluster:AlterGroup",
          "kafka-cluster:Connect",
          "kafka-cluster:DescribeGroup",
          "kafka-cluster:DescribeTopic",
          "kafka-cluster:ReadData"
        ]

        Resource = [
          aws_msk_serverless_cluster.interop_events[0].arn,
          "${local.msk_topic_iam_prefix}/event-store.*_agreement.events",
          "${local.msk_group_iam_prefix}/*-agreement-readmodel-writer"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "be_refactor_authorization_updater" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "InteropBeAuthorizationUpdater"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kafka-cluster:AlterGroup",
          "kafka-cluster:Connect",
          "kafka-cluster:DescribeGroup",
          "kafka-cluster:DescribeTopic",
          "kafka-cluster:ReadData"
        ]

        Resource = [
          aws_msk_serverless_cluster.interop_events[0].arn,
          "${local.msk_topic_iam_prefix}/event-store.*_catalog.events",
          "${local.msk_topic_iam_prefix}/event-store.*_agreement.events",
          "${local.msk_group_iam_prefix}/*-authorization-updater"
        ]
      },
      {
        Effect   = "Allow"
        Action   = "kms:Sign"
        Resource = aws_kms_key.interop.arn
      }
    ]
  })
}

resource "aws_iam_policy" "be_refactor_notifier_seeder" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "InteropBeNotifierSeeder"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kafka-cluster:AlterGroup",
          "kafka-cluster:Connect",
          "kafka-cluster:DescribeGroup",
          "kafka-cluster:DescribeTopic",
          "kafka-cluster:ReadData"
        ]

        Resource = [
          aws_msk_serverless_cluster.interop_events[0].arn,
          "${local.msk_topic_iam_prefix}/event-store.*_catalog.events",
          "${local.msk_topic_iam_prefix}/event-store.*_agreement.events",
          "${local.msk_group_iam_prefix}/*-notifier-seeder"
        ]
      },
      {
        Effect = "Allow"
        Action = "sqs:SendMessage",
        Resource = compact([
          module.persistence_events_queue.queue_arn,
          try(module.be_refactor_persistence_events_queue[0].queue_arn, "")
        ])
      }
    ]
  })
}
