data "aws_subnets" "eks_control_plane" {
  filter {
    name   = "vpc-id"
    values = [module.vpc_v2.vpc_id]
  }

  filter {
    name   = "cidr-block"
    values = toset(local.eks_control_plane_cidrs)
  }
}

data "aws_subnets" "eks_workload" {
  filter {
    name   = "vpc-id"
    values = [module.vpc_v2.vpc_id]
  }

  filter {
    name   = "cidr-block"
    values = toset(local.eks_workload_cidrs)
  }
}

locals {
  system_namespaces        = ["kube-system"]
  application_namespaces   = [format("%s*", var.env)]
  observability_namespaces = ["aws-observability"]
}

resource "aws_iam_policy" "fargate_profile_logging" {
  name = "EksFargateProfileLogging"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
          "logs:putRetentionPolicy",
          "logs:DeleteRetentionPolicy"
        ]
        Resource = "*"
      }
    ]
  })
}

# TODO: rename after migration
module "eks_v2" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.11.1"

  cluster_name    = format("%s-eks-cluster-%s", var.short_name, var.env)
  cluster_version = var.eks_k8s_version

  vpc_id                   = module.vpc_v2.vpc_id
  control_plane_subnet_ids = data.aws_subnets.eks_control_plane.ids
  cluster_ip_family        = "ipv4"
  # CIDR range for K8s services IPs. Just to avoid potential overlap with other networks
  cluster_service_ipv4_cidr = "10.1.0.0/21"

  cluster_security_group_additional_rules = {
    from_github_runners = {
      type                     = "ingress"
      from_port                = 0
      to_port                  = 65535
      protocol                 = "tcp"
      source_security_group_id = aws_security_group.github_runners_v2.id
    }

    from_vpn_clients = {
      type                     = "ingress"
      from_port                = 0
      to_port                  = 65535
      protocol                 = "tcp"
      source_security_group_id = aws_security_group.vpn_clients.id
    }
  }

  cluster_endpoint_public_access  = var.env == "dev" ? true : false
  cluster_endpoint_private_access = true

  authentication_mode                      = "API_AND_CONFIG_MAP"
  enable_cluster_creator_admin_permissions = false

  cluster_security_group_use_name_prefix = false

  iam_role_use_name_prefix = false

  cluster_enabled_log_types              = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  cloudwatch_log_group_retention_in_days = var.env == "prod" ? 365 : 90

  kms_key_enable_default_policy = true
  kms_key_administrators = [
    data.aws_iam_role.github_iac.arn,
    data.aws_iam_role.sso_admin.arn
  ]

  cluster_addons = {
    vpc-cni = {
      addon_version               = var.eks_vpc_cni_version
      resolve_conflicts_on_create = "NONE"
      resolve_conflicts_on_update = "NONE"
    }

    coredns = {
      addon_version               = var.eks_coredns_version
      resolve_conflicts_on_create = "NONE"
      resolve_conflicts_on_update = "NONE"
    }

    kube-proxy = {
      addon_version               = var.eks_kube_proxy_version
      resolve_conflicts_on_create = "NONE"
      resolve_conflicts_on_update = "NONE"
    }
  }

  fargate_profile_defaults = {
    subnet_ids               = data.aws_subnets.eks_workload.ids
    iam_role_use_name_prefix = false

    iam_role_additional_policies = {
      fargate_logging = aws_iam_policy.fargate_profile_logging.arn
    }
  }

  fargate_profiles = {
    system = {
      name      = "Interop-EKS-SystemProfile"
      selectors = [for ns in local.system_namespaces : { namespace = ns }]
    }

    application = {
      name      = "Interop-EKS-ApplicationProfile"
      selectors = [for ns in local.application_namespaces : { namespace = ns }]
    }

    observability = {
      name      = "Interop-EKS-ObservabilityProfile"
      selectors = [for ns in local.observability_namespaces : { namespace = ns }]
    }
  }
}


# applied to nodes
resource "aws_vpc_security_group_ingress_rule" "from_vpn_clients" {
  count = var.env == "dev" ? 1 : 0

  security_group_id = module.eks_v2.cluster_primary_security_group_id

  from_port                    = 0
  to_port                      = 65535
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.vpn_clients.id
}
