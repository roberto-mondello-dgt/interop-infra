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
  type        = string
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

variable "alb_logs_bucket_name" {
  type        = string
  description = "Name of the S3 Bucket containing ALB logs"
}

variable "tracing_aws_account_id" {
  type        = string
  description = "ID of the Tracing AWS account"
  default     = null
}

variable "tracing_vpc_id" {
  type        = string
  description = "ID of the VPC in the Tracing AWS account"
  default     = null
}

variable "analytics_qa_account_id" {
  type        = string
  description = "ID of Interop qa AWS account"
  default     = null
}

variable "analytics_qa_vpc_id" {
  type        = string
  description = "ID of the VPC in the Interop qa AWS account"
  default     = null
}

variable "analytics_k8s_namespace" {
  description = "Kubernetes namespace for the Analytics project"
  type        = string
}

variable "deployment_repo_name" {
  description = "Github repository name containing deployment automation"
  type        = string
}

variable "s3_reprocess_repo_name" {
  description = "Github repository name containing S3 reprocess script"
  type        = string
}

variable "github_runner_task_role_name" {
  description = "Name of the IAM role which is assumed by ECS tasks and allows to perform actions on the EKS cluster"
  type        = string
}

variable "msk_cluster_name" {
  description = "Name of the MSK cluster"
  type        = string
}

variable "msk_monitoring_app_audit_max_offset_lag_threshold" {
  description = "Threshold of the MaxOffsetLag alarm for the application audit MSK topic"
  type        = number
}

variable "msk_monitoring_app_audit_evaluation_periods" {
  description = "Evaluation periods of the MaxOffsetLag alarm for the application audit MSK topic"
  type        = number
}

variable "msk_monitoring_app_audit_period_seconds" {
  description = "Period in seconds of the MaxOffsetLag alarm for the application audit MSK topic"
  type        = number
}

variable "application_audit_producers_irsa_list" {
  description = "Names of the IRSA producers for application audit"
  type        = list(string)
  default     = []
}

variable "analytics_dev_account_id" {
  description = "ID of the Interop dev AWS account in which the Redshift dev cluster is deployed"
  type        = string
  default     = null
}

variable "analytics_redshift_dev_cluster_identifier" {
  description = "Identifier of the Redshift dev cluster"
  type        = string
  default     = null
}
