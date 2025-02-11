locals {
  be_iam_prefix = "interop-be"
}

module "be_jwt_audit_analytics_writer_irsa" {
  count = local.deploy_jwt_audit_resources ? 1 : 0

  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version   = "5.20.0"
  role_name = format("%s-jwt-audit-analytics-writer-%s", local.be_iam_prefix, var.env)
  oidc_providers = {
    cluster = {
      provider_arn               = data.aws_iam_openid_connect_provider.core_eks.arn
      namespace_service_accounts = ["${var.analytics_k8s_namespace}:interop-be-jwt-audit-analytics-writer"]
    }
  }

  role_policy_arns = {
    be_jwt_audit_analytics_writer = aws_iam_policy.be_jwt_audit_analytics_writer[0].arn
  }
}
