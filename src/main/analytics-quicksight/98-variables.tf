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

variable "vpc_id" {
  type        = string
  description = "ID of the interop VPC"
}

variable "analytics_subnet_ids" {
  type        = list(string)
  description = "IDs of the analytics subnets"
}


variable "quicksight_analytics_security_group_name" {
  type        = string
  description = "Name of the security group allowed to connect to redshift"
}

variable "quicksight_redshift_user_credential_secret" {
  type        = string
  description = "The id of the secret containing the credentials of the redshift quicksight user"
}

variable "redshift_cluster_identifier" {
  type        = string
  description = "The identifier of the redshift cluster"
}


variable "quicksight_identity_center_arn" {
  description = "The ARN of the AWS Identity Center instance used for QuickSight authentication"
  type        = string
  default     = null
}

variable "quicksight_identity_center_region" {
  description = "QuickSight landing region, the same of identity center"
  type        = string
  default     = null
}


variable "quicksight_notification_email" {
  description = "Email address where send notifications regarding QuickSight account and subscription"
  type        = string
  default     = null
}
