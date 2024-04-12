resource "aws_iam_role" "buildo_developers" {
  count = var.env == "dev" || var.env == "test" ? 1 : 0

  name = format("%s-buildo-developers-%s", var.short_name, var.env)

  managed_policy_arns = var.env == "dev" ? [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonSQSReadOnlyAccess"
  ] : ["arn:aws:iam::aws:policy/AmazonSQSReadOnlyAccess"]

  max_session_duration = 43200 # 12 hours

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          AWS = [
            "arn:aws:iam::309416224681:root",
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" # for debugging purposes
          ]
        }
      }
    ]
  })

  inline_policy {
    name = "KubeConfigPolicy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = "eks:DescribeCluster"
          Resource = module.eks_v2.cluster_arn
        }
      ]
    })
  }

  inline_policy {
    name = "LogsReadOnly"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "logs:DescribeLogGroups",
            "logs:DescribeQueries",
            "logs:DescribeQueryDefinitions",
            "logs:GetQueryResults",
            "logs:StopQuery"
          ]
          Resource = "*"
        },
        {
          Effect = "Allow"
          Action = [
            "logs:DescribeLogStreams",
            "logs:FilterLogEvents",
            "logs:GetLogEvents",
            "logs:GetLogGroupFields",
            "logs:StartQuery"
          ]
          Resource = [
            data.aws_cloudwatch_log_group.eks_application.arn,
            "${data.aws_cloudwatch_log_group.eks_application.arn}:log-stream:*"
          ]
        }
      ]
    })
  }

  inline_policy {
    name = "CloudWatchReadOnly"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "cloudwatch:List*",
            "cloudwatch:Get*",
            "cloudwatch:Describe*"
          ]
          Resource = "*"
        }
      ]
    })
  }

  inline_policy {
    name = "MSKReadOnly"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid    = "KafkaTopicsActions"
          Effect = "Allow"
          Action = [
            "kafka-cluster:Connect",
            "kafka-cluster:DescribeCluster",
            "kafka-cluster:DescribeTopic",
            "kafka-cluster:DescribeTopicDynamicConfiguration",
            "kafka-cluster:DescribeGroup",
            "kafka-cluster:AlterGroup",
            "kafka-cluster:ReadData",
          ]
          Resource = [
            "${local.msk_iam_prefix}:*/${local.interop_events_cluster_name}/${local.interop_events_cluster_uuid}",
            "${local.msk_topic_iam_prefix}/event-store.*",
            "${local.msk_group_iam_prefix}/buildo.*",
          ]
        }
      ]
    })
  }

  dynamic "inline_policy" {
    for_each = var.env == "dev" ? [1] : []

    content {
      name = "MSKWriteTopics"

      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Sid    = "KafkaTopicsActions"
            Effect = "Allow"
            Action = [
              "kafka-cluster:WriteData"
            ]
            Resource = [
              "${local.msk_topic_iam_prefix}/buildo.*",
            ]
          }
        ]
      })
    }
  }

  dynamic "inline_policy" {
    for_each = var.env == "dev" ? [1] : []

    content {
      name = "S3WriteApplicationDocuments"

      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "s3:PutObject",
              "s3:DeleteObject"
            ]
            Resource = format("%s/*", module.be_refactor_application_documents_bucket[0].s3_bucket_arn)
          }
        ]
      })
    }
  }

  dynamic "inline_policy" {
    for_each = var.env == "dev" ? [1] : []

    content {
      name = "KMS"

      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "kms:Sign",
              "kms:Verify"
            ]
            Resource = aws_kms_key.interop.arn
          }
        ]
      })
    }
  }

  dynamic "inline_policy" {
    for_each = var.env == "dev" ? [1] : []

    content {
      name = "SQS"

      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "sqs:*Message"
            ]
            Resource = module.be_refactor_persistence_events_queue[0].queue_arn
          }
        ]
      })
    }
  }
}


