locals {
  fargate_profiles_mapping = [for role in data.aws_iam_role.fargate_profiles : templatefile("./templates/aws-auth-role.tpl",
    {
      role_arn     = role.arn
      k8s_username = "system:node:{{SessionName}}"
      k8s_groups   = ["system:bootstrappers", "system:nodes", "system:node-proxier"]
  })]

  sso_full_admin_mapping = templatefile("./templates/aws-auth-role.tpl",
    {
      # cannot use data object for the SSO role because it would return a different ARN format
      role_arn     = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.sso_full_admin_role_name}"
      k8s_username = "sso-fulladmin-{{SessionName}}"
      k8s_groups   = ["system:masters"]
  })

  sso_readonly_mapping = templatefile("./templates/aws-auth-role.tpl",
    {
      # cannot use data object for the SSO role because it would return a different ARN format
      role_arn     = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.sso_readonly_role_name}"
      k8s_username = "sso-readonly-{{SessionName}}"
      k8s_groups   = ["readonly-group"]
  })

  github_runner_mapping = templatefile("./templates/aws-auth-role.tpl",
    {
      role_arn     = data.aws_iam_role.github_runner.arn
      k8s_username = "github-runner"
      k8s_groups   = ["system:masters"]
  })

  admin_users_mapping = [for user in data.aws_iam_user.admin : templatefile("./templates/aws-auth-user.tpl",
    {
      user_arn     = user.arn
      k8s_username = user.user_name
      k8s_groups   = ["system:masters"]
  })]

  readonly_users_mapping = [for user in data.aws_iam_user.readonly : templatefile("./templates/aws-auth-user.tpl",
    {
      user_arn     = user.arn
      k8s_username = user.user_name
      k8s_groups   = ["readonly-group"]
  })]
}

data "aws_iam_role" "fargate_profiles" {
  for_each = toset(var.fargate_profiles_roles_names)

  name = each.key
}

data "aws_iam_role" "github_runner" {
  name = var.github_runner_role_name
}

data "aws_iam_user" "admin" {
  for_each = toset(var.iam_users_k8s_admin)

  user_name = each.key
}

data "aws_iam_user" "readonly" {
  for_each = toset(var.iam_users_k8s_readonly)

  user_name = each.key
}

resource "kubernetes_config_map_v1" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = join("", concat(local.fargate_profiles_mapping, [local.sso_full_admin_mapping, local.sso_readonly_mapping, local.github_runner_mapping]))
    mapUsers = join("", local.admin_users_mapping, local.readonly_users_mapping)
  }
}
