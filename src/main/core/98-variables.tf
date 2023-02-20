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

variable "bastion_host_ami_id" {
  description = "AMI ID of the bastion host on EC2"
  type = string
}

variable "bastion_host_instance_type" {
  description = "Instance type of the bastion host on EC2"
  type = string
}

variable "bastion_host_private_ip" {
  description = "Private IP of the bastion host on EC2"
  type = string
}

variable "bastion_host_security_group_name" {
  description = "Name of the bastion host security group"
  type = string
}

variable "bastion_host_ssh_cidr" {
  description = "CIDR from where bastion host will accept ssh"
  type = string
}

variable "bastion_host_key_pair" {
  description = "Name of the bastion host key pair"
  type = string
}