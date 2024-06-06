data "aws_iam_role" "fargate_profiles" {
  for_each = toset(var.fargate_profiles_roles_names)

  name = each.key
}

locals {
  fargate_profiles_mapping = [for role in data.aws_iam_role.fargate_profiles : templatefile("./templates/aws-auth-role.tpl",
    {
      role_arn     = role.arn
      k8s_username = "system:node:{{SessionName}}"
      k8s_groups   = ["system:bootstrappers", "system:nodes", "system:node-proxier"]
  })]
}

resource "kubernetes_config_map_v1" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  # TODO: refactor with yamlencode once TF version is updated
  data = {
    mapRoles = join("", local.fargate_profiles_mapping)
  }
}
