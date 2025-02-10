data "aws_vpc" "core" {
  id = var.vpc_id
}

data "aws_subnets" "analytics" {
  filter {
    name   = "subnet-id"
    values = var.analytics_subnet_ids
  }
}

data "aws_security_group" "vpn_clients" {
  id = var.vpn_clients_security_group_id
}

data "aws_eks_cluster" "core" {
  name = var.eks_cluster_name
}

data "aws_iam_openid_connect_provider" "core_eks" {
  url = data.aws_eks_cluster.core.identity[0].oidc[0].issuer
}

data "aws_security_group" "core_eks_cluster_node" {
  id = var.eks_cluster_node_security_group_id
}

data "aws_s3_bucket" "jwt_details" {
  bucket = var.jwt_details_bucket_name
}

data "aws_sns_topic" "platform_alarms" {
  name = var.sns_topic_name
}
