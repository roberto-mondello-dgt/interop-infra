locals {
  msk_iam_prefix = "arn:aws:kafka:${var.aws_region}:${data.aws_caller_identity.current.account_id}"

  platform_events_cluster_name = (local.deploy_be_refactor_infra ?
  aws_msk_cluster.platform_events[0].cluster_name : null)

  platform_events_cluster_uuid = (local.deploy_be_refactor_infra ?
  split("/", aws_msk_cluster.platform_events[0].arn)[2] : null)
  debezium_event_store_offsets_topic = "debezium.event-store.offsets"

  msk_topic_iam_prefix = (local.deploy_be_refactor_infra
    ? "${local.msk_iam_prefix}:topic/${local.platform_events_cluster_name}/${local.platform_events_cluster_uuid}"
  : null)
  msk_group_iam_prefix = (local.deploy_be_refactor_infra
    ? "${local.msk_iam_prefix}:group/${local.platform_events_cluster_name}/${local.platform_events_cluster_uuid}"
  : null)
}

resource "aws_iam_policy" "be_refactor_debezium_postgresql" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "DebeziumPostgresqlPolicyEs1"

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
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/__*debezium.*",
          "${local.msk_topic_iam_prefix}/event-store.*",
          "${local.msk_group_iam_prefix}/*debezium.*",
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

  name = "InteropBeCatalogProcessRefactorPolicyEs1"

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
        Resource = compact([
          format("%s/*", module.application_documents_bucket.s3_bucket_arn),
          try(format("%s/*", module.be_refactor_application_documents_bucket[0].s3_bucket_arn), "")
        ])
      }
    ]
  })
}

resource "aws_iam_policy" "be_refactor_catalog_outbound_writer" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "InteropBeCatalogOutboundWriterEs1"

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
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/event-store.*_catalog.events",
          "${local.msk_group_iam_prefix}/*catalog-outbound-writer"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "kafka-cluster:AlterGroup",
          "kafka-cluster:DescribeGroup",
          "kafka-cluster:DescribeTopic",
          "kafka-cluster:ReadData",
          "kafka-cluster:WriteData"
        ]

        Resource = [
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/outbound.*_catalog.events",
          "${local.msk_group_iam_prefix}/*catalog-outbound-writer"
        ]
      }
    ]
  })
}

# TODO: refactor Kafka policies to be reusable
resource "aws_iam_policy" "be_refactor_catalog_readmodel_writer" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "InteropBeCatalogReadModelWriterEs1"

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
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/event-store.*_catalog.events",
          "${local.msk_group_iam_prefix}/*catalog-readmodel-writer"
        ]
      }
    ]
  })
}

# TODO: refactor Kafka policies to be reusable
resource "aws_iam_policy" "be_refactor_attribute_registry_readmodel_writer" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "InteropBeAttributeRegistryReadModelWriterEs1"

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
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/event-store.*_attribute_registry.events",
          "${local.msk_group_iam_prefix}/*attribute-registry-readmodel-writer"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "be_refactor_agreement_email_sender" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "InteropBeAgreementEmailSenderEs1"

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
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/event-store.*_agreement.events",
          "${local.msk_group_iam_prefix}/*agreement-email-sender"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "be_refactor_agreement_process" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "InteropBeAgreementProcessRefactorPolicyEs1"

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
        Resource = compact([
          format("%s/*", module.application_documents_bucket.s3_bucket_arn),
          try(format("%s/*", module.be_refactor_application_documents_bucket[0].s3_bucket_arn), ""),
        ])
      },
      {
        Effect = "Allow"
        Action = "sqs:SendMessage"
        Resource = compact([
          module.persistence_events_queue.queue_arn,
          try(module.be_refactor_persistence_events_queue[0].queue_arn, "")
        ])
      },
      {
        Effect = "Allow"
        Action = "sqs:SendMessage"
        Resource = compact([
          module.certified_mail_queue.queue_arn,
          try(module.be_refactor_certified_mail_queue[0].queue_arn, "")
        ])
      },
    ]
  })
}

resource "aws_iam_policy" "be_refactor_agreement_outbound_writer" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "InteropBeAgreementOutboundWriterEs1"

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
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/event-store.*_agreement.events",
          "${local.msk_group_iam_prefix}/*agreement-outbound-writer"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "kafka-cluster:AlterGroup",
          "kafka-cluster:DescribeGroup",
          "kafka-cluster:DescribeTopic",
          "kafka-cluster:ReadData",
          "kafka-cluster:WriteData"
        ]

        Resource = [
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/outbound.*_agreement.events",
          "${local.msk_group_iam_prefix}/*agreement-outbound-writer"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "be_refactor_agreement_readmodel_writer" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "InteropBeAgreementReadModelWriterEs1"

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
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/event-store.*_agreement.events",
          "${local.msk_group_iam_prefix}/*agreement-readmodel-writer"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "be_refactor_eservice_descriptors_archiver" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "InteropBeEserviceDescriptorsArchiverEs1"

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
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/event-store.*_agreement.events",
          "${local.msk_group_iam_prefix}/*eservice-descriptors-archiver"
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

resource "aws_iam_policy" "be_refactor_purpose_process" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "InteropBePurposeProcessRefactorPolicyEs1"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
        ]
        Resource = compact([
          format("%s/*", module.application_documents_bucket.s3_bucket_arn),
          try(format("%s/*", module.be_refactor_application_documents_bucket[0].s3_bucket_arn), ""),
        ])
      },
      {
        Effect = "Allow"
        Action = "sqs:SendMessage"
        Resource = compact([
          module.persistence_events_queue.queue_arn,
          try(module.be_refactor_persistence_events_queue[0].queue_arn, "")
        ])
      }
    ]
  })
}

resource "aws_iam_policy" "be_refactor_purpose_outbound_writer" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "InteropBePurposeOutboundWriterEs1"

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
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/event-store.*_purpose.events",
          "${local.msk_group_iam_prefix}/*purpose-outbound-writer"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "kafka-cluster:AlterGroup",
          "kafka-cluster:DescribeGroup",
          "kafka-cluster:DescribeTopic",
          "kafka-cluster:ReadData",
          "kafka-cluster:WriteData"
        ]

        Resource = [
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/outbound.*_purpose.events",
          "${local.msk_group_iam_prefix}/*purpose-outbound-writer"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "be_refactor_purpose_readmodel_writer" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "InteropBePurposeReadModelWriterEs1"

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
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/event-store.*_purpose.events",
          "${local.msk_group_iam_prefix}/*purpose-readmodel-writer"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "be_refactor_client_readmodel_writer" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "InteropBeClientReadModelWriterEs1"

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
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/event-store.*_authorization.events",
          "${local.msk_group_iam_prefix}/*client-readmodel-writer"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "be_refactor_key_readmodel_writer" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "InteropBeKeyReadModelWriterEs1"

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
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/event-store.*_authorization.events",
          "${local.msk_group_iam_prefix}/*key-readmodel-writer"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "be_refactor_tenant_readmodel_writer" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "InteropBeTenantReadModelWriterEs1"

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
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/event-store.*_tenant.events",
          "${local.msk_group_iam_prefix}/*tenant-readmodel-writer"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "be_refactor_tenant_outbound_writer" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "InteropBeTenantOutboundWriterEs1"

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
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/event-store.*_tenant.events",
          "${local.msk_group_iam_prefix}/*tenant-outbound-writer"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "kafka-cluster:AlterGroup",
          "kafka-cluster:DescribeGroup",
          "kafka-cluster:DescribeTopic",
          "kafka-cluster:ReadData",
          "kafka-cluster:WriteData"
        ]

        Resource = [
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/outbound.*_tenant.events",
          "${local.msk_group_iam_prefix}/*purpose-outbound-writer"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "be_refactor_compute_agreements_consumer" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "InteropBeComputeAgreementsConsumerEs1"

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
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/event-store.*_tenant.events",
          "${local.msk_group_iam_prefix}/*compute-agreements-consumer"
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

resource "aws_iam_policy" "be_refactor_authorization_updater" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "InteropBeAuthorizationUpdaterEs1"

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
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/event-store.*_catalog.events",
          "${local.msk_topic_iam_prefix}/event-store.*_agreement.events",
          "${local.msk_topic_iam_prefix}/event-store.*_purpose.events",
          "${local.msk_topic_iam_prefix}/event-store.*_authorization.events",
          "${local.msk_group_iam_prefix}/*authorization-updater"
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

  name = "InteropBeNotifierSeederEs1"

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
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/event-store.*_catalog.events",
          "${local.msk_topic_iam_prefix}/event-store.*_agreement.events",
          "${local.msk_topic_iam_prefix}/event-store.*_purpose.events",
          "${local.msk_topic_iam_prefix}/event-store.*_authorization.events",
          "${local.msk_group_iam_prefix}/*notifier-seeder"
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

resource "aws_iam_policy" "be_refactor_producer_key_readmodel_writer" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "InteropBeProducerKeyReadModelWriterEs1"

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
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/event-store.*_authorization.events",
          "${local.msk_group_iam_prefix}/*producer-key-readmodel-writer"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "be_refactor_producer_keychain_readmodel_writer" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "InteropBeProducerKeychainReadModelWriterEs1"

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
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/event-store.*_authorization.events",
          "${local.msk_group_iam_prefix}/*producer-keychain-readmodel-writer"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "be_refactor_authorization_server" {
  count = local.deploy_auth_server_refactor ? 1 : 0

  name = "InteropBeRefactorAuthorizationServerPolicyEs1"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DynamoDBTokenGenerationStates"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Query"
        ]
        Resource = [
          aws_dynamodb_table.token_generation_states[0].arn,
          format("%s/index/*", aws_dynamodb_table.token_generation_states[0].arn)
        ]
      },
      {
        Sid      = "KMSGenerateToken"
        Effect   = "Allow"
        Action   = "kms:Sign"
        Resource = aws_kms_key.interop.arn
      },
      {
        Sid    = "S3WriteJWTAuditFallback"
        Effect = "Allow"
        Action = "s3:PutObject"
        Resource = compact([
          format("%s/*", module.generated_jwt_details_fallback_bucket.s3_bucket_arn),
          try(format("%s/*", module.be_refactor_generated_jwt_details_fallback_bucket[0].s3_bucket_arn), "")
        ])
      },
      {
        Sid    = "MSKWriteJWTAudit"
        Effect = "Allow"
        Action = [
          "kafka-cluster:AlterGroup",
          "kafka-cluster:Connect",
          "kafka-cluster:DescribeGroup",
          "kafka-cluster:DescribeTopic",
          "kafka-cluster:ReadData",
          "kafka-cluster:WriteData"
        ]

        Resource = [
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/*_authorization-server.generated-jwt",
          "${local.msk_group_iam_prefix}/*-authorization-server"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "be_refactor_agreement_platformstate_writer" {
  count = local.deploy_auth_server_refactor ? 1 : 0

  name = "InteropBeAgreementPlatformStateWriterEs1"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "MSKAgreementEvents"
        Effect = "Allow"
        Action = [
          "kafka-cluster:AlterGroup",
          "kafka-cluster:Connect",
          "kafka-cluster:DescribeGroup",
          "kafka-cluster:DescribeTopic",
          "kafka-cluster:ReadData"
        ]
        Resource = [
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/event-store.*_agreement.events",
          "${local.msk_group_iam_prefix}/*-agreement-platformstate-writer"
        ]
      },
      {
        Sid    = "DynamoDBPlatformStates"
        Effect = "Allow"
        Action = [
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:UpdateItem"
        ]
        Resource = compact([
          aws_dynamodb_table.platform_states[0].arn,
          format("%s/index/*", aws_dynamodb_table.platform_states[0].arn),
          try(aws_dynamodb_table.dev_refactor_platform_states[0].arn, ""),
          try(format("%s/index/*", aws_dynamodb_table.dev_refactor_platform_states[0].arn), "")
        ])
      },
      {
        Sid    = "DynamoDBTokenGenStates"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:UpdateItem"
        ]
        Resource = compact([
          aws_dynamodb_table.token_generation_states[0].arn,
          format("%s/index/*", aws_dynamodb_table.token_generation_states[0].arn),
          try(aws_dynamodb_table.dev_refactor_token_generation_states[0].arn, ""),
          try(format("%s/index/*", aws_dynamodb_table.dev_refactor_token_generation_states[0].arn), "")
        ])
      }
    ]
  })
}

resource "aws_iam_policy" "be_refactor_authorization_platformstate_writer" {
  count = local.deploy_auth_server_refactor ? 1 : 0

  name = "InteropBeAuthorizationPlatformStateWriterEs1"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "MSKAgreementEvents"
        Effect = "Allow"
        Action = [
          "kafka-cluster:AlterGroup",
          "kafka-cluster:Connect",
          "kafka-cluster:DescribeGroup",
          "kafka-cluster:DescribeTopic",
          "kafka-cluster:ReadData"
        ]
        Resource = [
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/event-store.*_authorization.events",
          "${local.msk_group_iam_prefix}/*-authorization-platformstate-writer"
        ]
      },
      {
        Sid    = "DynamoDBPlatformStates"
        Effect = "Allow"
        Action = [
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:UpdateItem"
        ]
        Resource = compact([
          aws_dynamodb_table.platform_states[0].arn,
          format("%s/index/*", aws_dynamodb_table.platform_states[0].arn),
          try(aws_dynamodb_table.dev_refactor_platform_states[0].arn, ""),
          try(format("%s/index/*", aws_dynamodb_table.dev_refactor_platform_states[0].arn), "")
        ])
      },
      {
        Sid    = "DynamoDBTokenGenStates"
        Effect = "Allow"
        Action = [
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:UpdateItem"
        ]
        Resource = compact([
          aws_dynamodb_table.token_generation_states[0].arn,
          format("%s/index/*", aws_dynamodb_table.token_generation_states[0].arn),
          try(aws_dynamodb_table.dev_refactor_token_generation_states[0].arn, ""),
          try(format("%s/index/*", aws_dynamodb_table.dev_refactor_token_generation_states[0].arn), "")
        ])
      }
    ]
  })
}

resource "aws_iam_policy" "be_refactor_catalog_platformstate_writer" {
  count = local.deploy_auth_server_refactor ? 1 : 0

  name = "InteropBeCatalogPlatformStateWriterEs1"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "MSKAgreementEvents"
        Effect = "Allow"
        Action = [
          "kafka-cluster:AlterGroup",
          "kafka-cluster:Connect",
          "kafka-cluster:DescribeGroup",
          "kafka-cluster:DescribeTopic",
          "kafka-cluster:ReadData"
        ]
        Resource = [
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/event-store.*_catalog.events",
          "${local.msk_group_iam_prefix}/*-catalog-platformstate-writer"
        ]
      },
      {
        Sid    = "DynamoDBPlatformStates"
        Effect = "Allow"
        Action = [
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:UpdateItem"
        ]
        Resource = compact([
          aws_dynamodb_table.platform_states[0].arn,
          format("%s/index/*", aws_dynamodb_table.platform_states[0].arn),
          try(aws_dynamodb_table.dev_refactor_platform_states[0].arn, ""),
          try(format("%s/index/*", aws_dynamodb_table.dev_refactor_platform_states[0].arn), "")
        ])
      },
      {
        Sid    = "DynamoDBTokenGenStates"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:UpdateItem"
        ]
        Resource = compact([
          aws_dynamodb_table.token_generation_states[0].arn,
          format("%s/index/*", aws_dynamodb_table.token_generation_states[0].arn),
          try(aws_dynamodb_table.dev_refactor_token_generation_states[0].arn, ""),
          try(format("%s/index/*", aws_dynamodb_table.dev_refactor_token_generation_states[0].arn), "")
        ])
      }
    ]
  })
}

resource "aws_iam_policy" "be_refactor_purpose_platformstate_writer" {
  count = local.deploy_auth_server_refactor ? 1 : 0

  name = "InteropBePurposePlatformStateWriterEs1"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "MSKAgreementEvents"
        Effect = "Allow"
        Action = [
          "kafka-cluster:AlterGroup",
          "kafka-cluster:Connect",
          "kafka-cluster:DescribeGroup",
          "kafka-cluster:DescribeTopic",
          "kafka-cluster:ReadData"
        ]
        Resource = [
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/event-store.*_purpose.events",
          "${local.msk_group_iam_prefix}/*-purpose-platformstate-writer"
        ]
      },
      {
        Sid    = "DynamoDBPlatformStates"
        Effect = "Allow"
        Action = [
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:UpdateItem"
        ]
        Resource = compact([
          aws_dynamodb_table.platform_states[0].arn,
          format("%s/index/*", aws_dynamodb_table.platform_states[0].arn),
          try(aws_dynamodb_table.dev_refactor_platform_states[0].arn, ""),
          try(format("%s/index/*", aws_dynamodb_table.dev_refactor_platform_states[0].arn), "")
        ])
      },
      {
        Sid    = "DynamoDBTokenGenStates"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:UpdateItem"
        ]
        Resource = compact([
          aws_dynamodb_table.token_generation_states[0].arn,
          format("%s/index/*", aws_dynamodb_table.token_generation_states[0].arn),
          try(aws_dynamodb_table.dev_refactor_token_generation_states[0].arn, ""),
          try(format("%s/index/*", aws_dynamodb_table.dev_refactor_token_generation_states[0].arn), "")
        ])
      }
    ]
  })
}

resource "aws_iam_policy" "be_datalake_interface_exporter" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "InteropBeDataLakeInterfaceExporterEs1"

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
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/event-store.*_catalog.events",
          "${local.msk_group_iam_prefix}/*datalake-interface-exporter"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
        ]
        Resource = format("%s/*", module.application_documents_bucket.s3_bucket_arn)
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
        ]
        Resource = format("%s/*", module.datalake_interface_export_bucket.s3_bucket_arn)
      }
    ]
  })
}

resource "aws_iam_policy" "be_delegation_items_archiver" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "InteropBeDelegationItemsArchiverEs1"

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
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/event-store.*_delegation.events",
          "${local.msk_group_iam_prefix}/*delegation-items-archiver"
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

resource "aws_iam_policy" "be_delegation_readmodel_writer" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "InteropBeDelegationReadModelWriterEs1"

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
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/event-store.*_delegation.events",
          "${local.msk_group_iam_prefix}/*delegation-readmodel-writer"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "be_delegation_process" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "InteropBeDelegationProcessPolicyEs1"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = [format("%s/*", module.application_documents_bucket.s3_bucket_arn)]
      }
    ]
  })
}

resource "aws_iam_policy" "be_refactor_token_details_persister" {
  count = local.deploy_auth_server_refactor ? 1 : 0

  name = "InteropBeTokenDetailsPersisterRefactorEs1"

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
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/*_authorization-server.generated-jwt",
          "${local.msk_group_iam_prefix}/*token-details-persister"
        ]
      },
      {
        Effect   = "Allow",
        Action   = "s3:PutObject",
        Resource = format("%s/*", module.generated_jwt_details_bucket.s3_bucket_arn)
      }
    ]
  })
}

resource "aws_iam_policy" "be_client_purpose_updater" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "InteropBeClientPurposeUpdaterEs1"

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
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/event-store.*_purpose.events",
          "${local.msk_group_iam_prefix}/*client-purpose-updater"
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

resource "aws_iam_policy" "be_delegation_outbound_writer" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "InteropBeDelegationOutboundWriterEs1"

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
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/event-store.*_delegation.events",
          "${local.msk_group_iam_prefix}/*delegation-outbound-writer"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "kafka-cluster:AlterGroup",
          "kafka-cluster:DescribeGroup",
          "kafka-cluster:DescribeTopic",
          "kafka-cluster:ReadData",
          "kafka-cluster:WriteData"
        ]

        Resource = [
          aws_msk_cluster.platform_events[0].arn,
          "${local.msk_topic_iam_prefix}/outbound.*_delegation.events",
          "${local.msk_group_iam_prefix}/*delegation-outbound-writer"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "be_refactor_token_generation_readmodel_checker" {
  count = local.deploy_auth_server_refactor ? 1 : 0

  name = "InteropBeRefactorTokenGenerationReadmodelCheckerEs1"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DynamoDBAuthServerTables"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = compact([
          aws_dynamodb_table.platform_states[0].arn,
          format("%s/index/*", aws_dynamodb_table.platform_states[0].arn),
          try(aws_dynamodb_table.dev_refactor_platform_states[0].arn, ""),
          try(format("%s/index/*", aws_dynamodb_table.dev_refactor_platform_states[0].arn), ""),
          aws_dynamodb_table.token_generation_states[0].arn,
          format("%s/index/*", aws_dynamodb_table.token_generation_states[0].arn),
          try(aws_dynamodb_table.dev_refactor_token_generation_states[0].arn, ""),
          try(format("%s/index/*", aws_dynamodb_table.dev_refactor_token_generation_states[0].arn), "")
        ])
      }
    ]
  })
}

resource "aws_iam_policy" "be_ipa_certified_attributes_importer" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "InteropBeIPACertifiedAttributesImporterEs1"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "kms:Sign"
        Resource = aws_kms_key.interop.arn
      }
    ]
  })
}
