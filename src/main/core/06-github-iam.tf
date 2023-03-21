data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

data "aws_iam_policy_document" "github_assume_ecr" {
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
        "repo:pagopa/interop-be-*:*",
        "repo:pagopa/pdnd-interop-frontend:*"
      ]
    }
  }
}

resource "aws_iam_role" "github_ecr" {
  name = format("%s-github-ecr-%s", var.short_name, var.env)

  assume_role_policy = data.aws_iam_policy_document.github_assume_ecr.json

  inline_policy {
    name = "GithubEcrPolicy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = "ecr:GetAuthorizationToken"
          Resource = "*"
        },
        {
          Effect = "Allow"
          Action = [
            "ecr:BatchGetImage",
            "ecr:BatchCheckLayerAvailability",
            "ecr:CompleteLayerUpload",
            "ecr:GetDownloadUrlForLayer",
            "ecr:InitiateLayerUpload",
            "ecr:PutImage",
            "ecr:UploadLayerPart"
          ]
          Resource = values(aws_ecr_repository.app)[*].arn
        }
      ]
    })
  }
}

data "aws_iam_policy_document" "github_assume_ecs" {
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

      values = formatlist("repo:%s:*", toset(var.github_runners_allowed_repos))
    }
  }
}

resource "aws_iam_role" "github_ecs" {
  name = format("%s-github-ecs-%s", var.short_name, var.env)

  assume_role_policy = data.aws_iam_policy_document.github_assume_ecs.json

  inline_policy {
    name = "GithubEcsPolicy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = "ecs:RunTask"
          Resource = [
            aws_ecs_task_definition.github_runner.arn_without_revision,
            "${aws_ecs_task_definition.github_runner.arn_without_revision}:*"
          ]
          Condition = {
            StringEquals = {
              "ecs:cluster" = aws_ecs_cluster.github_runners.arn
            }
          }
        },
        {
          Effect = "Allow"
          Action = "ecs:StopTask"
          Resource = "*"
          Condition = {
            StringEquals = {
              "ecs:cluster" = aws_ecs_cluster.github_runners.arn
            }
          }
        },
        {
          Effect = "Allow"
          Action = "iam:PassRole"
          Resource = [
            aws_iam_role.github_runner_task_exec.arn,
            aws_iam_role.github_runner_task.arn
          ]
        }
      ]
    })
  }
}

