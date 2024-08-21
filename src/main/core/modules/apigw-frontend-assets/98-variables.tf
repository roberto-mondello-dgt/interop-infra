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

variable "maintenance_mode" {
  description = "Determines whether the API Gateway is in maintenance mode or not"
  type        = bool
  default     = false
}

variable "maintenance_openapi_path" {
  description = "Path to the OpenAPI maintenance file, relative to TF root module (e.g. './openapi/foo/bar.yaml')"
  type        = string
  default     = "./openapi/maintenance/frontend-assets-maintenance.yaml"
}

variable "create_cloudwatch_alarm" {
  description = "If true, a CloudWatch alarm for the 5XXError metric is created for the current API Gateway"
  type        = bool
}

variable "create_cloudwatch_dashboard" {
  description = "If true, a CloudWatch dashboard is created for the current API Gateway"
  type        = bool
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic for alarms notifications"
  type        = string
  default     = null
}

variable "alarm_5xx_threshold" {
  description = "Threshold to trigger 5xx APIGW alarm"
  type        = number
  default     = 0
}

variable "alarm_5xx_period" {
  description = "Period (in seconds) over which the 5xx APIGW alarm statistic is applied"
  type        = number
  default     = 0
}

variable "alarm_5xx_eval_periods" {
  description = "Number of periods to evaluate for the 5xx APIGW alarm"
  type        = number
  default     = 0
}

variable "alarm_5xx_datapoints" {
  description = "Number of breaching datapoints in the evaluation period to trigger the 5xx APIGW alarm"
  type        = number
  default     = 0
}
