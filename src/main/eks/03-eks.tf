locals {
  system_namespaces        = ["kube-system", "default"]
  application_namespaces   = [format("%s*", var.env)]
  observability_namespaces = ["aws-observability"]
  tools_namespaces         = ["vault", "jenkins"]
  devtools_namespaces      = ["vault", "jenkins", "nexus"]
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.6.0"

  cluster_name    = format("%s-eks-%s", var.short_name, var.env)
  cluster_version = var.k8s_version

  # managed outside of this module
  manage_aws_auth_configmap = false

  vpc_id            = data.aws_vpc.this.id
  subnet_ids        = data.aws_subnet.this[*].id
  cluster_ip_family = "ipv4"

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  # ⚠️  DO NOT MODIFY, it will cause cluster replacement
  cluster_security_group_use_name_prefix = false
  cluster_security_group_name            = var.cluster_sec_group_name
  cluster_security_group_description     = "EKS Cluster Communication"
  create_node_security_group             = false

  iam_role_name            = format("%s-eks-%s-EksClusterRole", var.short_name, var.env)
  iam_role_use_name_prefix = false

  cluster_enabled_log_types              = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  cloudwatch_log_group_retention_in_days = var.env == "prod" ? 365 : 90

  cluster_encryption_config = {}
  create_kms_key            = false

  cluster_addons = {
    vpc-cni = {
      addon_version     = var.vpc_cni_version
      resolve_conflicts = "OVERWRITE"
    }

    coredns = {
      addon_version     = var.coredns_version
      resolve_conflicts = "OVERWRITE"
    }

    kube-proxy = {
      addon_version     = var.kube_proxy_version
      resolve_conflicts = "OVERWRITE"
    }
  }

  fargate_profile_defaults = {
    create_iam_role = false
    iam_role_arn    = aws_iam_role.fargate_pod_exec.arn
  }

  fargate_profiles = {
    system = {
      name      = var.fargate_system_profile_name
      selectors = [for ns in local.system_namespaces : { namespace = ns }]
    }

    application = {
      name      = var.fargate_application_profile_name
      selectors = [for ns in local.application_namespaces : { namespace = ns }]
    }

    observability = {
      name      = var.fargate_observability_profile_name
      selectors = [for ns in local.observability_namespaces : { namespace = ns }]
    }

    # TODO: refactor this profile
    tools = var.env == "dev" ? {
      name      = "EKSFargateProfileDevTools-c8F5N8JSC4Ki"
      selectors = [for ns in local.devtools_namespaces : { namespace = ns }]
      } : {
      name      = var.fargate_tools_profile_name
      selectors = [for ns in local.tools_namespaces : { namespace = ns }]
    }
  }
}
