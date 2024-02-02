variable "env" {
  type        = string
  description = "Environment name"
}

variable "api_name" {
  description = "Name of the API"
  type        = string
}

variable "openapi_relative_path" {
  description = "Path to the OpenAPI definition file, relative to TF root module (e.g. './openapi/foo/bar.yaml')"
  type        = string
}

variable "domain_name" {
  description = "Domain name to be assigned to the API Gateway"
  type        = string
}

variable "vpc_link_id" {
  description = "ID of the VPC Link to be used for backend integration"
  type        = string
}

variable "web_acl_arn" {
  description = "ARN of the WAF Web ACL to associate to this APIGW's stage"
  type        = string
  default     = null
}

variable "access_log_group_arn" {
  description = "ARN of the log group where to store APIGW access logs"
  type        = string
  default     = null
}

variable "privacy_notices_bucket_name" {
  description = "Name of the S3 bucket containing the privacy notices"
  type        = string
}

variable "frontend_additional_assets_bucket_name" {
  description = "Name of the S3 bucket containing frontend additional assets"
  type        = string
}