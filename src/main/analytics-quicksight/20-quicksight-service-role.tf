# - All the resources in this file are required to use secret_arn in 
#   aws_quicksight_data_source terraform resources.

resource "aws_iam_role" "quicksight_service_role" {
  count = local.deploy_redshift_cluster ? 1 : 0

  name = "aws-quicksight-service-role-v0"
  path = "/service-role/"

  assume_role_policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "quicksight.amazonaws.com"
          },
          "Effect": "Allow"
        }
      ]
    }
  EOF
}

resource "aws_iam_role" "quicksight_secret_manager_service_role" {
  count = local.deploy_redshift_cluster ? 1 : 0

  name = "aws-quicksight-secretsmanager-role-v0"
  path = "/service-role/"

  assume_role_policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "quicksight.amazonaws.com"
          },
          "Effect": "Allow"
        }
      ]
    }
  EOF
}
resource "aws_iam_policy" "quicksight_secret_manager_service_role_policy" {
  count = local.deploy_redshift_cluster ? 1 : 0

  name        = "AWSQuickSightSecretsManagerReadOnlyPolicy"
  path        = "/service-role/"
  description = "Policy used by QuickSight to access SecretsManager resources (read-only)"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [
          data.aws_secretsmanager_secret_version.quicksight_user_secret_version[0].arn
        ]
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "quicksight_secret_manager_service_role_policy_attachment" {
  count = local.deploy_redshift_cluster ? 1 : 0

  role       = aws_iam_role.quicksight_secret_manager_service_role[0].name
  policy_arn = aws_iam_policy.quicksight_secret_manager_service_role_policy[0].arn
}
