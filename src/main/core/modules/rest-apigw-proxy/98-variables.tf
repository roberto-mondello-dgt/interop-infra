variable "env" {
  type        = string
  description = "Environment name"
}

variable "api_name" {
  description = "Name of the API"
  type        = string
}

variable "api_version" {
  description = "(optional) Version of the API exposed by this APIGW"
  type        = string
  default     = null
}

variable "domain_name" {
  description = "Domain name to be assigned to the API Gateway"
  type        = string
}

variable "vpc_link_id" {
  description = "ID of the VPC Link to be used for backend integration"
  type        = string
}

variable "nlb_domain_name" {
  description = "Domain name of the NLB used to route backend requests"
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

variable "frontend_redirect_uri" {
  description = "URI location of frontend redirect (e.g. '/ui')"
  type        = string
  default     = null
}
