data "aws_vpc_endpoint" "s3" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.eu-south-1.s3"
}

data "aws_prefix_list" "s3" {
  prefix_list_id = data.aws_vpc_endpoint.s3.prefix_list_id
}

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

  ingress {
    from_port       = 443
    to_port         = 5439
    protocol        = "tcp"
    prefix_list_ids = [data.aws_prefix_list.s3.id]
  }

  egress {
    from_port       = 443
    to_port         = 5439
    protocol        = "tcp"
    prefix_list_ids = [data.aws_prefix_list.s3.id]
  }
}

resource "aws_redshift_subnet_group" "analytics" {
  name       = format("%s-analytics-%s", local.project, var.env)
  subnet_ids = var.analytics_subnet_ids
}