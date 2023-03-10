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
  type        = list(string)
  description = "Availability zones to use"
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "bastion_host_ami_id" {
  description = "AMI ID of the bastion host on EC2"
  type        = string
}

variable "bastion_host_instance_type" {
  description = "Instance type of the bastion host on EC2"
  type        = string
}

variable "bastion_host_private_ip" {
  description = "Private IP of the bastion host on EC2"
  type        = string
}

variable "bastion_host_security_group_name" {
  description = "Name of the bastion host security group"
  type        = string
}

variable "bastion_host_ssh_cidr" {
  description = "CIDR from where bastion host will accept ssh"
  type        = string
}

variable "bastion_host_key_pair" {
  description = "Name of the bastion host key pair"
  type        = string
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster created in a separate module"
  type        = string
  default     = null
}

variable "persistence_management_cluster_id" {
  description = "ID of the Aurora cluster - persistence management"
  type        = string
}

variable "persistence_management_database_name" {
  description = "SQL database name in the Aurora cluster - persistence management"
  type        = string
}

variable "persistence_management_engine_version" {
  description = "Engine version of the Aurora cluster - persistence management"
  type        = string
}

variable "persistence_management_instance_class" {
  description = "Instance class of the Aurora cluster - persistence management"
  type        = string
}

variable "persistence_management_subnet_group_name" {
  description = "Subnet group name of the Aurora cluster - persistence management"
  type        = string
}

variable "persistence_management_parameter_group_name" {
  description = "Name of the DB parameter group for Aurora cluster - persistence management"
  type        = string
}

variable "persistence_management_parameter_group_family" {
  description = "Family of the DB parameter group for Aurora cluster - persistence management"
  type        = string
}

variable "persistence_management_master_username" {
  description = "Master username - persistence management"
  type        = string
}

variable "persistence_management_primary_instance_id" {
  description = "Identifier of the primary instance in the Aurora cluster - persistence management"
  type        = string
}

variable "persistence_management_replica1_instance_id" {
  description = "Identifier of the replica1 instance in the Aurora cluster - persistence management"
  type        = string
}

variable "persistence_management_replica2_instance_id" {
  description = "Identifier of the replica2 instance in the Aurora cluster - persistence management"
  type        = string
}

variable "read_model_cluster_id" {
  description = "DocDB cluster ID - read model"
  type        = string
}

variable "read_model_master_username" {
  description = "Master username - read model"
  type        = string
}

variable "read_model_engine_version" {
  description = "Engine version of the DocDB cluster - read model"
  type        = string
}

variable "read_model_db_port" {
  description = "DB port of the DocDB cluster - read model"
  type        = string
  default     = 27017
}

variable "read_model_instance_class" {
  description = "Instance class of the DocDB cluster - read model"
  type        = string
}

variable "read_model_subnet_group_name" {
  description = "Subnet group name of the DocDB cluster - read model"
  type        = string
}

variable "read_model_parameter_group_name" {
  description = "Name of cluster parameter group for the DocDB cluster - read model"
  type = string
}

variable "read_model_parameter_group_family" {
  description = "Family of the parameter group (based on engine version) for the DocDB cluster - read model"
  type = map
  default = {
    "3.6.0" = "docdb3.6"
    "4.0.0" = "docdb4.0"
  }
}

variable "notification_events_table_ttl_enabled" {
  description = "Enable or disable TTL in 'interop-notification-events' table"
  type = bool
}
