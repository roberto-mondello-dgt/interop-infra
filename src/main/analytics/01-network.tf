resource "aws_security_group" "analytics" {
  name        = format("%s-redshift-cluster-%s", local.project, var.env)
  description = "SG for the Redshift cluster"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5439
    protocol        = "tcp"
    security_groups = [var.vpn_clients_security_group_id]
  }

  ingress {
    from_port       = 5432
    to_port         = 5439
    protocol        = "tcp"
    security_groups = [var.eks_cluster_node_security_group_id]
  }
}

resource "aws_redshift_subnet_group" "analytics" {
  name       = format("%s-analytics-%s", local.project, var.env)
  subnet_ids = var.analytics_subnet_ids
}