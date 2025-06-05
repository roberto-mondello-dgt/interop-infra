resource "aws_redshift_subnet_group" "analytics_from_qa_to_dev" {
  count = local.deploy_redshift_cross_account_to_dev ? 1 : 0

  name       = format("%s-%s", local.project, var.analytics_redshift_dev_cluster_identifier)
  subnet_ids = data.aws_subnets.analytics.ids
}

resource "aws_security_group" "analytics_from_qa_to_dev" {
  count = local.deploy_redshift_cross_account_to_dev ? 1 : 0

  name        = format("redshift/%s-analytics-from-%s-to-dev", local.project, var.env)
  description = format("SG for the Analytics Redshift-managed VPC endpoint from %s to dev", var.env)
  vpc_id      = data.aws_vpc.core.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [data.aws_security_group.vpn_clients.id]
    description     = "From VPN clients"
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [data.aws_security_group.core_eks_cluster_node.id]
    description     = "From EKS pods"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_redshift_endpoint_access" "analytics_from_qa_to_dev" {
  count = local.deploy_redshift_cross_account_to_dev ? 1 : 0

  endpoint_name          = format("%s-%s", local.project, var.analytics_redshift_dev_cluster_identifier)
  resource_owner         = var.analytics_dev_account_id
  cluster_identifier     = var.analytics_redshift_dev_cluster_identifier
  subnet_group_name      = aws_redshift_subnet_group.analytics_from_qa_to_dev[0].name
  vpc_security_group_ids = [aws_security_group.analytics_from_qa_to_dev[0].id]
}