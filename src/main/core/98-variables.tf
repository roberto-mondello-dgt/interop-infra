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

variable "tags" {
  type = map(any)
  default = {
    CreatedBy = "Terraform"
  }
}

variable "azs" {
  type = list(string)
  description = "Availability zones to use"
  default = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}
