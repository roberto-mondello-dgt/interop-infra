data "aws_iam_role" "fargate_profiles" {
  for_each = toset(var.fargate_profiles_roles_names)

  name = each.key
}

data "aws_iam_role" "admin" {
  for_each = toset(var.k8s_admin_roles_names)

  name = each.key
}

data "aws_iam_role" "iac_readonly" {
  name = var.iac_k8s_readonly_role_name
}

data "aws_iam_user" "admin" {
  for_each = toset(var.users_k8s_admin)

  user_name = each.key
}

data "aws_iam_user" "readonly" {
  for_each = toset(var.users_k8s_readonly)

  user_name = each.key
}

data "aws_iam_role" "buildo_devs" {
  count = var.env == "dev" ? 1 : 0

  name = "interop-buildo-developers-dev"
}

data "aws_iam_role" "qa_runner" {
  count = var.env == "dev" || var.env == "qa" ? 1 : 0

  name = "interop-github-qa-runner-task-${var.env}"
}

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

  admin_roles_mapping = [for role in data.aws_iam_role.admin : templatefile("./templates/aws-auth-role.tpl",
    {
      role_arn     = role.arn
      k8s_username = role.name
      k8s_groups   = ["system:masters"]
  })]

  iac_readonly_role_mapping = templatefile("./templates/aws-auth-role.tpl",
    {
      role_arn     = data.aws_iam_role.iac_readonly.arn
      k8s_username = data.aws_iam_role.iac_readonly.name
      k8s_groups   = ["iac-readonly-group"]
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

  buildo_devs_mapping = var.env == "dev" ? templatefile("./templates/aws-auth-role.tpl",
    {
      role_arn     = data.aws_iam_role.buildo_devs[0].arn
      k8s_username = "buildo-devs-{{SessionName}}"
      k8s_groups   = ["buildo-devs"]
  }) : ""

  qa_runner_mapping = var.env == "dev" || var.env == "qa" ? templatefile("./templates/aws-auth-role.tpl",
    {
      role_arn     = data.aws_iam_role.qa_runner[0].arn
      k8s_username = data.aws_iam_role.qa_runner[0].name
      k8s_groups   = ["qa-runner-group"]
  }) : ""
}

resource "kubernetes_config_map_v1" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  # TODO: refactor with yamlencode once TF version is updated
  data = {
    mapRoles = join("", concat(local.fargate_profiles_mapping,
      [local.sso_full_admin_mapping, local.sso_readonly_mapping, local.iac_readonly_role_mapping, local.buildo_devs_mapping, local.qa_runner_mapping],
    local.admin_roles_mapping))
    mapUsers = join("", local.admin_users_mapping, local.readonly_users_mapping)
  }
}
