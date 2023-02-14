variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "env" {
  type        = string
  description = "Environment name"
}

variable "short_name" {
  type        = string
  description = "Project short name used in resource names"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the EKS cluster"
}

variable "subnets_ids" {
  type        = list(string)
  description = "Subnets IDs for the EKS cluster"
}

variable "k8s_version" {
  type        = string
  description = "Kubernetes version used by the EKS cluster"
}

variable "vpc_cni_version" {
  type        = string
  description = "vpc-cni addon version"
}

variable "coredns_version" {
  type        = string
  description = "coredns addon version"
}

variable "kube_proxy_version" {
  type        = string
  description = "kube-proxy addon version"
}

# ⚠️  DO NOT MODIFY, it will cause cluster replacement
variable "cluster_sec_group_name" {
  type        = string
  description = "Name of the cluster security group"
}

# ⚠️  DO NOT MODIFY, it may cause downtime
variable "fargate_system_profile_name" {
  type        = string
  description = "Name of the 'system' Fargate profile"
}

# ⚠️  DO NOT MODIFY, it may cause downtime
variable "fargate_application_profile_name" {
  type        = string
  description = "Name of the 'application' Fargate profile"
}

# ⚠️  DO NOT MODIFY, it may cause downtime
variable "fargate_observability_profile_name" {
  type        = string
  description = "Name of the 'observability' Fargate profile"
}

# ⚠️  DO NOT MODIFY, it may cause downtime
variable "fargate_tools_profile_name" {
  type        = string
  description = "Name of the 'tools' Fargate profile (test, prod)"
  default     = ""
}

variable "tags" {
  type = map(any)
  default = {
    CreatedBy = "Terraform"
  }
}
