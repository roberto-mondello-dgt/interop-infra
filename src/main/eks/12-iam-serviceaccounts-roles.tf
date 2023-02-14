module "elb_iam_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.11.1"

  role_name = format("%s-eks-%s-EksLoadBalancerControllerRole", var.short_name, var.env)

  oidc_providers = {
    eks = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }

  attach_load_balancer_controller_policy = true
}

module "adot_iam_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.11.1"

  role_name = format("%s-eks-%s-ADOT-ServiceAccount-Role", var.short_name, var.env)

  oidc_providers = {
    eks = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["aws-observability:adot-collector"]
    }
  }

  role_policy_arns = {
    cloudwatch = data.aws_iam_policy.cloudwatch_agent_server_policy.arn
  }
}
