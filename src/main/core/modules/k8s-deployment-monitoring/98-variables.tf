variable "env" {
  type        = string
  description = "Environment name"
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "k8s_namespace" {
  description = "Namespace of the K8s deployment"
  type        = string
}

variable "k8s_deployment_name" {
  description = "Name of the K8s deployment"
  type        = string
}

variable "sns_topics_arns" {
  description = "ARNs of the SNS topics for alarms notifications"
  type        = list(string)
  default     = []
}

variable "create_alarms" {
  description = "If set to true, creates the alarms"
  type        = bool
}

variable "create_dashboard" {
  description = "If set to true, creates the dashboard"
  type        = bool
}

variable "avg_cpu_alarm_threshold" {
  description = "Threshold to trigger the AVG cpu alarm"
  type        = number
}

variable "avg_memory_alarm_threshold" {
  description = "Threshold to trigger the AVG memory alarm"
  type        = number
}

variable "alarm_period_seconds" {
  description = "Period (in seconds) over which the alarm statistic is applied"
  type        = number
}

variable "alarm_eval_periods" {
  description = "Number of periods to evaluate for the alarms"
  type        = number
  default     = 1
}

variable "alarm_datapoints" {
  description = "Number of breaching datapoints in the evaluation period to trigger the alarms"
  type        = number
  default     = 1
}
