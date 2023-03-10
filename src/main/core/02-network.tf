locals {
  eks_subnets_cidrs    = ["172.32.5.0/24", "172.32.6.0/24", "172.32.7.0/24"]
  aurora_subnets_cidrs = ["172.32.3.0/25", "172.32.3.128/25", "172.32.4.0/24"]
  docdb_subnets_cidrs  = ["100.64.0.0/24", "100.64.1.0/24", "100.64.2.0/24"]
  eks_subnets_names    = [for idx, subn in local.eks_subnets_cidrs :
                        format("%s-private-subnet-%d-%s", var.short_name, idx+1, var.env)]
  aurora_subnets_names = [for idx, subn in local.aurora_subnets_cidrs :
                          format("%s-private-subnet-aurora-%d-%s", var.short_name, idx+1, var.env)]
  docdb_subnets_names  = [for idx, subn in local.docdb_subnets_cidrs :
                          format("%s-private-subnet-docdb-%d-%s", var.short_name, idx+1, var.env)]
}

# TODO: set cidrs as variables/cidrsubnet function? shorten subnets name?
# use module's default igw, nat, eip names
# map_public_ip_on_launch should be true
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                  = format("%s-vpc-%s", var.short_name, var.env)
  cidr                  = "172.32.0.0/21"
  secondary_cidr_blocks = ["100.64.0.0/16"]
  azs                   = var.azs

  enable_dns_hostnames = true
  enable_dns_support   = true

  create_igw         = true
  igw_tags           = { "Name": format("%s-ig-%s", var.short_name, var.env) }
  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnets          = ["172.32.0.0/24", "172.32.1.0/24", "172.32.2.0/24"]
  public_subnet_names     = [for idx, az in var.azs : format("%s-public-subnet-%d-%s", var.short_name, idx+1, var.env)]
  public_subnet_tags      = { "kubernetes.io/role/elb": 1 }
  public_route_table_tags = { "Name": "Public Route Table" }
  map_public_ip_on_launch = false

  private_subnets          = local.eks_subnets_cidrs
  private_subnet_names     = local.eks_subnets_names
  private_subnet_tags      = { "kubernetes.io/role/internal-elb": 1 }
  private_route_table_tags = { "Name": "Private Route Table" }

  database_subnets             = concat(local.aurora_subnets_cidrs, local.docdb_subnets_cidrs)
  database_subnet_names        = concat(local.aurora_subnets_names, local.docdb_subnets_names)
  create_database_subnet_group = false
}

data "aws_eks_cluster" "backend" {
  count = var.eks_cluster_name != null ? 1 : 0

  name = var.eks_cluster_name
}

data "aws_security_groups" "backend" {
  filter {
    name = "group-id"
    values = try(data.aws_eks_cluster.backend[0].vpc_config[0].security_group_ids, [])
  }
}
