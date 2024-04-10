locals {
  eks_workload_cidrs         = ["10.0.0.0/21", "10.0.8.0/21", "10.0.16.0/21"]
  ext_lbs_cidrs              = ["10.0.24.0/22", "10.0.28.0/22", "10.0.32.0/22"]
  int_lbs_cidrs              = ["10.0.36.0/22", "10.0.40.0/22", "10.0.44.0/22"]
  egress_cidrs               = ["10.0.48.0/24", "10.0.49.0/24", "10.0.50.0/24"]
  eks_control_plane_cidrs    = ["10.0.51.0/24", "10.0.52.0/24", "10.0.53.0/24"]
  aurora_persist_manag_cidrs = ["10.0.54.0/24", "10.0.55.0/24", "10.0.56.0/24"]
  docdb_read_model_cidrs     = ["10.0.57.0/24", "10.0.58.0/24", "10.0.59.0/24"]
  vpce_cidrs                 = ["10.0.60.0/24", "10.0.61.0/24", "10.0.62.0/24"]
  bastion_host_cidrs         = ["10.0.63.0/24"]
  msk_interop_events_cidrs = (local.deploy_be_refactor_infra ?
  ["10.0.64.0/24", "10.0.65.0/24", "10.0.66.0/24"] : [])

  eks_workload_subnets_names = [for idx, subn in local.eks_workload_cidrs :
  format("%s-eks-workload-%d-%s", var.short_name, idx + 1, var.env)]

  ext_lbs_subnets_names = [for idx, subn in local.ext_lbs_cidrs :
  format("%s-ext-lbs-%d-%s", var.short_name, idx + 1, var.env)]

  int_lbs_subnets_names = [for idx, subn in local.int_lbs_cidrs :
  format("%s-int-lbs-%d-%s", var.short_name, idx + 1, var.env)]

  egress_subnets_names = [for idx, subn in local.egress_cidrs :
  format("%s-egress-%d-%s", var.short_name, idx + 1, var.env)]

  eks_control_plane_subnets_names = [for idx, subn in local.eks_control_plane_cidrs :
  format("%s-eks-cp-%d-%s", var.short_name, idx + 1, var.env)]

  aurora_persist_manag_subnets_names = [for idx, subn in local.aurora_persist_manag_cidrs :
  format("%s-aurora-persist-manag-%d-%s", var.short_name, idx + 1, var.env)]

  docdb_read_model_subnets_names = [for idx, subn in local.docdb_read_model_cidrs :
  format("%s-docdb-read-model-%d-%s", var.short_name, idx + 1, var.env)]

  vpce_subnets_names = [for idx, subn in local.vpce_cidrs :
  format("%s-vpce-%d-%s", var.short_name, idx + 1, var.env)]

  bastion_host_subnets_names = [for idx, subn in local.bastion_host_cidrs :
  format("%s-bastion-host-%d-%s", var.short_name, idx + 1, var.env)]

  msk_interop_events_subnets_names = [for idx, subn in local.msk_interop_events_cidrs :
  format("%s-msk-events-%d-%s", var.short_name, idx + 1, var.env) if local.deploy_be_refactor_infra]
}

# TODO: rename module and vpc after migration
module "vpc_v2" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = format("%s-vpc-v2-%s", var.short_name, var.env)
  cidr = "10.0.0.0/16"
  azs  = var.azs

  enable_dns_hostnames = true
  enable_dns_support   = true

  create_igw              = true
  map_public_ip_on_launch = false
  enable_nat_gateway      = true
  # This will create N instances of NAT (N = #AZs) in the first N public subnets specified in 'public_subnets'
  one_nat_gateway_per_az = true

  # Order matters: the first N subnets (N = #AZs) will host a NAT instance. See 'one_nat_gateway_per_az'
  public_subnets      = concat(local.egress_cidrs, local.ext_lbs_cidrs, local.bastion_host_cidrs)
  public_subnet_names = concat(local.egress_subnets_names, local.ext_lbs_subnets_names, local.bastion_host_subnets_names)

  # TODO: some of these subnets should be in the 'intra' class, but we need to move the TF address without destroying the subnets
  private_subnets      = concat(local.eks_workload_cidrs, local.int_lbs_cidrs, local.eks_control_plane_cidrs, local.vpce_cidrs)
  private_subnet_names = concat(local.eks_workload_subnets_names, local.int_lbs_subnets_names, local.eks_control_plane_subnets_names, local.vpce_subnets_names)

  # TODO: MSK subnets should be in the 'intra' class, but we need to move the TF address without destroying the subnets
  database_subnets                   = concat(local.aurora_persist_manag_cidrs, local.docdb_read_model_cidrs, local.msk_interop_events_cidrs)
  database_subnet_names              = concat(local.aurora_persist_manag_subnets_names, local.docdb_read_model_subnets_names, local.msk_interop_events_subnets_names)
  create_database_subnet_group       = false
  create_database_subnet_route_table = true
  create_database_nat_gateway_route  = false
}

data "aws_subnets" "ext_lbs" {
  filter {
    name   = "vpc-id"
    values = [module.vpc_v2.vpc_id]
  }

  filter {
    name   = "cidr-block"
    values = toset(local.ext_lbs_cidrs)
  }
}

data "aws_subnets" "int_lbs" {
  filter {
    name   = "vpc-id"
    values = [module.vpc_v2.vpc_id]
  }

  filter {
    name   = "cidr-block"
    values = toset(local.int_lbs_cidrs)
  }
}

resource "aws_ec2_tag" "ext_lbs" {
  for_each = toset(data.aws_subnets.ext_lbs.ids)

  resource_id = each.value
  key         = "kubernetes.io/role/elb"
  value       = "1"
}

resource "aws_ec2_tag" "int_lbs" {
  for_each = toset(data.aws_subnets.int_lbs.ids)

  resource_id = each.value
  key         = "kubernetes.io/role/internal-elb"
  value       = "1"
}
