# TODO: refactor after migration, this is just to avoid changes on resources
locals {
  readonly_group_id = {
    dev  = "U3WXG8UIJ9RX"
    test = "1FMY1O5DDBI6F"
    prod = "GPWD3F8DRJX0"
  }
  admin_group_id = {
    dev  = "1M1WLYQF0H4M6"
    test = "K7XMXFU3K1HI"
    prod = "Z26ZRCOEUGV3"
  }
}

data "aws_iam_policy_document" "root_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [format("arn:aws:iam::%s:root", data.aws_caller_identity.current.account_id)]
    }
  }
}

resource "aws_iam_role" "full_admin" {
  name                = format("%s-iam-users-%s-FullAdminRole", var.short_name, var.env)
  assume_role_policy  = data.aws_iam_policy_document.root_assume_policy.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

resource "aws_iam_role" "read_only" {
  name                = format("%s-iam-users-%s-ReadOnlyRole", var.short_name, var.env)
  assume_role_policy  = data.aws_iam_policy_document.root_assume_policy.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
}

data "aws_iam_policy_document" "cfn_full_admin_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["cloudformation.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cfn_full_admin" {
  name                = format("%s-iam-users-%s-CFNFullAdminRole", var.short_name, var.env)
  assume_role_policy  = data.aws_iam_policy_document.cfn_full_admin_assume_policy.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

resource "aws_iam_group" "read_only" {
  name = format("%s-iam-users-%s-ReadOnlyGroup-%s", var.short_name, var.env, local.readonly_group_id[var.env])
  path = "/engineers/readonly/"
}

resource "aws_iam_group_policy" "read_only" {
  name  = "AssumeReadOnlyRolePolicy"
  group = aws_iam_group.read_only.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sts:AssumeRole",
        ]
        Resource = aws_iam_role.read_only.arn
      },
    ]
  })
}

resource "aws_iam_group" "admin" {
  name = format("%s-iam-users-%s-AdminGroup-%s", var.short_name, var.env, local.admin_group_id[var.env])
  path = "/engineers/admin/"
}

resource "aws_iam_group_policy" "admin" {
  name  = "AssumeAdminRolePolicy"
  group = aws_iam_group.admin.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sts:AssumeRole",
        ]
        Resource = aws_iam_role.full_admin.arn
      },
    ]
  })
}


resource "aws_iam_policy" "user_credentials_self_service" {
  count = (var.env == "dev") ? 1 : 0

  name = "UserCredentialsSelfService"
  policy = templatefile("./iam_policies/user_credentials_self_service.tftpl.json",
    {
      account_id = data.aws_caller_identity.current.account_id
  })
}

resource "aws_iam_group" "external_backend_devs" {
  count = (var.env == "dev") ? 1 : 0

  name = "ExternalBackendDevelopers"
  path = "/externals/engineers/backend/"
}

resource "aws_iam_group_policy_attachment" "external_backend_devs_credentials" {
  count = (var.env == "dev") ? 1 : 0

  group      = aws_iam_group.external_backend_devs[0].name
  policy_arn = aws_iam_policy.user_credentials_self_service[0].arn
}

data "aws_iam_policy" "read_only" {
  name = "ReadOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "external_backend_devs_read_only" {
  count = (var.env == "dev") ? 1 : 0

  group      = aws_iam_group.external_backend_devs[0].name
  policy_arn = data.aws_iam_policy.read_only.arn
}
