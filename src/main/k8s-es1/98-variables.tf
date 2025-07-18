variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "app_name" {
  type        = string
  description = "App name"
}

variable "env" {
  type        = string
  default     = "dev"
  description = "Environment name"
}

variable "tags" {
  type = map(any)
  default = {
    CreatedBy = "Terraform"
  }
}

variable "be_prefix" {
  description = "Name prefix used by backend apps"
  type        = string
}

variable "eks_cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "fargate_profiles_roles_names" {
  type        = list(string)
  description = "Names of the Fargate profiles roles"
}

variable "sso_full_admin_role_name" {
  type        = string
  description = "Name of the SSO 'FullAdmin' role"
}

variable "enable_fluentbit_process_logs" {
  type        = bool
  description = "Enables FluentBit process logs to help with debugging. WARNING: produces A LOT of logs and could significantly increase CloudWatch costs"
  default     = false
}

variable "container_logs_cloudwatch_retention_days" {
  type        = number
  description = "Set the retention period on CloudWatch (in days) for container logs"
}

variable "kube_state_metrics_image_version_tag" {
  type        = string
  description = "Image version tag of Kube State Metrics"
}

variable "kube_state_metrics_cpu" {
  type        = string
  description = "CPU resource for Kube State Metrics"
}

variable "kube_state_metrics_memory" {
  type        = string
  description = "Memory resource for Kube State Metrics"
}

variable "adot_collector_role_name" {
  type        = string
  description = "Name of the IAM role to be assumed by the ADOT service account"
}

variable "adot_collector_image_uri" {
  type        = string
  description = "Docker image URI for the ADOT collector"
}

variable "aws_load_balancer_controller_role_name" {
  type        = string
  description = "Name of the IAM role to be assumed by the AWS Load Balancer Controller service account"
}

variable "debezium_postgresql_image_uri" {
  type        = string
  description = "Image URI for Debezium Postgresql connector"
  default     = null
}

variable "debezium_postgresql_replicas" {
  type        = number
  description = "Number of replicas for Debezium Postgresql connector"
  default     = 0
}

variable "debezium_postgresql_cpu" {
  type        = string
  description = "CPU for Debezium Postgresql deployment"
  default     = null
}

variable "debezium_postgresql_memory" {
  type        = string
  description = "Memory for Debezium Postgresql deployment"
  default     = null
}

variable "debezium_postgresql_role_name" {
  type        = string
  description = "Name of the IAM role for Debezium Postgresql service account"
  default     = null
}

variable "debezium_postgresql_msk_cluster_arn" {
  type        = string
  description = "ARN of the MSK cluster"
  default     = null
}

variable "debezium_postgresql_aurora_cluster_id" {
  type        = string
  description = "ID of the Aurora cluster hosting the Postgresql database"
  default     = null
}

variable "debezium_postgresql_database_name" {
  type        = string
  description = "Name of the Postgresql database"
  default     = null
}

variable "debezium_postgresql_credentials_secret_name" {
  type        = string
  description = "Name of the secret containing Postgresql credentials for Debezium"
  default     = null
}

variable "debezium_routing_partitions" {
  type        = number
  description = "Number of topic partitions for transforms.PartitionRouting"
}

variable "keda_chart_version" {
  type        = string
  description = "KEDA Helm Chart version"
  default     = null
}

variable "keda_operator_cpu" {
  type        = string
  description = "KEDA Operator CPU resources limits"
  default     = "250m"
}

variable "keda_operator_memory" {
  type        = string
  description = "KEDA Operator RAM resources limits"
  default     = "250Mi"
}

variable "keda_webhooks_cpu" {
  type        = string
  description = "KEDA Admission Webhooks CPU resources limits"
  default     = "250m"
}

variable "keda_webhooks_memory" {
  type        = string
  description = "KEDA Admission Webhooks RAM resources limits"
  default     = "250Mi"
}

variable "keda_metrics_server_cpu" {
  type        = string
  description = "KEDA Metrics Server CPU resources limits"
  default     = "250m"
}

variable "keda_metrics_server_memory" {
  type        = string
  description = "KEDA Metrics Server RAM resources limits"
  default     = "250Mi"
}

variable "cluster_autoscaler_chart_version" {
  type        = string
  description = "Cluster Autoscaler Helm chart version"
  default     = null
}

variable "cluster_autoscaler_irsa_name" {
  type        = string
  description = "IRSA name for Cluster Autoscaler"
  default     = null
}
