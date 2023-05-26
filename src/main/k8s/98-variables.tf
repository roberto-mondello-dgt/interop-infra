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

variable "sso_readonly_role_name" {
  type        = string
  description = "Name of the SSO readonly role"
}

variable "github_runner_role_name" {
  type        = string
  description = "Name of the Github runner role used to deploy K8s manifests"
}

variable "iam_users_k8s_admin" {
  type        = list(string)
  description = "IAM users to be granted admin access in the cluster"
  default     = []
}

variable "iam_users_k8s_readonly" {
  type        = list(string)
  description = "IAM users to be granted readonly access in the cluster"
  default     = []
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
