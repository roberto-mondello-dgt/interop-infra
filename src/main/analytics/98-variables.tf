variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "env" {
  type        = string
  description = "Environment name"
}

variable "tags" {
  type = map(any)
  default = {
    CreatedBy = "Terraform"
  }
}

variable "sso_admin_role_name" {
  type        = string
  description = "Name of the SSO admin role"
}

variable "azs" {
  type        = list(string)
  description = "Availability zones to use"
}

variable "vpc_id" {
  type        = string
  description = "ID of the interop VPC"
}

variable "analytics_subnet_ids" {
  type        = list(string)
  description = "IDs of the analytics subnets"
}

variable "vpn_clients_security_group_id" {
  type        = string
  description = "ID of the VPN clients SG"
}

variable "eks_cluster_name" {
  type = string
  description = "Name of the EKS cluster accessing the analytics cluster"
}

variable "eks_cluster_node_security_group_id" {
  type        = string
  description = "ID of EKS cluster node SG"
}

variable "redshift_master_username" {
  type        = string
  description = "Master username of the Redshift database"
  default     = "root"
}

variable "redshift_cluster_nodes_number" {
  type        = number
  description = "Number of nodes for the Redshift cluster"
}

variable "redshift_cluster_nodes_type" {
  type        = string
  description = "Type of the nodes for the Redshift cluster"
}

variable "redshift_cluster_port" {
  type        = string
  description = "Port on which the Redshift cluster listens for incoming traffic"
  default     = "5439"
}

variable "jwt_details_bucket_name" {
  type        = string
  description = "Name of the S3 Bucket containing the generated jwt to be ingested in Redshift"
}
