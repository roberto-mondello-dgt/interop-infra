data "aws_iam_policy_document" "buildo_github_assume" {
  count = var.env == "dev" ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:pagopa/interop-be-monorepo:*",
      ]
    }
  }
}

resource "aws_iam_role" "buildo_github_k8s" {
  count = var.env == "dev" ? 1 : 0

  name = format("%s-buildo-github-k8s-%s", var.short_name, var.env)

  assume_role_policy = data.aws_iam_policy_document.buildo_github_assume[0].json

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
}

locals {
  msk_iam_prefix = "arn:aws:kafka:${var.aws_region}:${data.aws_caller_identity.current.account_id}"

  interop_events_cluster_name = (var.env == "dev" ?
  aws_msk_serverless_cluster.interop_events[0].cluster_name : null)

  interop_events_cluster_uuid = (var.env == "dev" ?
  split("/", aws_msk_serverless_cluster.interop_events[0].arn)[2] : null)
}

resource "aws_iam_role" "buildo_developers" {
  count = var.env == "dev" ? 1 : 0

  name = format("%s-buildo-developers-%s", var.short_name, var.env)

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
    name = "MSKInteropEvents"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "kafka-cluster:Connect",
            "kafka-cluster:DescribeCluster",
            "kafka-cluster:*Topic",
            "kafka-cluster:*TopicDynamicConfiguration",
            "kafka-cluster:*Data*",
            "kafka-cluster:*Group",
            "kafka-cluster:*TransactionalId"
          ]
          Resource = [
            "${local.msk_iam_prefix}:*/${local.interop_events_cluster_name}/${local.interop_events_cluster_uuid}",
            "${local.msk_iam_prefix}:*/${local.interop_events_cluster_name}/${local.interop_events_cluster_uuid}/*"
          ]
        }
      ]
    })
  }
}


