data "aws_iam_policy_document" "fargate_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks-fargate-pods.amazonaws.com"]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [format("arn:aws:eks:%s:%s:fargateprofile/*", var.aws_region, data.aws_caller_identity.current.account_id)]
    }
  }
}

data "aws_iam_policy_document" "fargate_pod_exec_inline" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:putRetentionPolicy",
      "logs:DeleteRetentionPolicy"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "elasticfilesystem:ClientMount",
      "elasticfilesystem:ClientWrite",
      "elasticfilesystem:ClientRootAccess"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "fargate_pod_exec" {
  name                = format("%s-eks-%s-EksFargatePodExecutionRole", var.short_name, var.env)
  assume_role_policy  = data.aws_iam_policy_document.fargate_assume_role.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"]

  inline_policy {
    name = "EksFargatePodExecInline"
    policy = data.aws_iam_policy_document.fargate_pod_exec_inline.json
  }
}
