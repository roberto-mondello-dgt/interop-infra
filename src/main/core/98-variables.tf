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

variable "sso_admin_role_name" {
  type        = string
  description = "Name of the SSO admin role"
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

variable "persistence_management_number_instances" {
  description = "Number of instances of the Aurora cluster - persistence management"
  type        = number

  validation {
    condition     = var.persistence_management_number_instances > 0
    error_message = "The number of instances must be greater than 0"
  }
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

variable "read_model_number_instances" {
  description = "Number of instances of the DocDB cluster - read model"
  type        = number

  validation {
    condition     = var.read_model_number_instances > 0
    error_message = "The number of instances must be greater than 0"
  }
}

variable "read_model_subnet_group_name" {
  description = "Subnet group name of the DocDB cluster - read model"
  type        = string
}

variable "read_model_parameter_group_name" {
  description = "Name of cluster parameter group for the DocDB cluster - read model"
  type        = string
}

variable "read_model_parameter_group_family" {
  description = "Family of the parameter group (based on engine version) for the DocDB cluster - read model"
  type        = map(any)
  default = {
    "3.6.0" = "docdb3.6"
    "4.0.0" = "docdb4.0"
  }
}

variable "notification_events_table_ttl_enabled" {
  description = "Enable or disable TTL in 'interop-notification-events' table"
  type        = bool
}

variable "backend_integration_alb_name" {
  description = "Name of the ALB created by the aws-load-balancer-controller"
  type        = string
}

variable "github_runners_allowed_repos" {
  description = "Github repositories names (format: organization/repo-name) allowed to assume the ECS role to start/stop self-hosted runners"
  type        = list(string)
}

variable "github_runners_cpu" {
  description = "vCPU to allocate for each GH runner execution (e.g. 1024)"
  type        = number
}

variable "github_runners_memory" {
  description = "RAM to allocate for each GH runner execution (e.g. 2048)"
  type        = number
}

variable "github_runners_image_uri" {
  description = "URI of the runner image"
  type        = string
}

variable "dns_interop_base_domain" {
  description = "Base DNS domain for the Interoperability product. According to PagoPA eng standard, it usually is a third level domain (e.g. product.example.com)"
  type        = string
}

variable "dns_interop_dev_ns_records" {
  description = "NS records for the Interop 'dev' hosted zone. Used to grant DNS delegation for the subdomain"
  type        = list(string)
  default     = []
}

variable "dns_interop_uat_ns_records" {
  description = "NS records for the Interop 'uat' hosted zone. Used to grant DNS delegation for the subdomain"
  type        = list(string)
  default     = []
}

variable "data_lake_account_id" {
  description = "AWS account ID of the DataLake team for token data ingestion"
  type        = string
}

variable "data_lake_external_id" {
  description = "External ID of the DataLake team for token data ingestion. Passed by them when assuming the role"
  type        = string
}

variable "probing_registry_reader_role_arn" {
  description = "ARN of the role used by the probing registry reader to access the bucket containing eservices list"
  type        = string
  default     = null
}

variable "probing_domain_ns_records" {
  description = "NS records for the probing DNS domain"
  type        = list(string)
  default     = []
}

variable "interop_auth_openapi_path" {
  description = "Relative path of Interop auth OpenAPI definition file"
  type        = string
}

variable "interop_api_openapi_path" {
  description = "Relative path of Interop API OpenAPI definition file"
  type        = string
}

variable "interop_landing_domain_name" {
  description = "Domain name of the Interop landing page"
  type        = string
}

# TODO: remove once this log group is imported
variable "lambda_eks_application_log_group_arn" {
  description = "EKS Application log group arn"
  type        = string
}

variable "eks_k8s_version" {
  type        = string
  description = "K8s version used in the EKS cluster"
}

variable "eks_vpc_cni_version" {
  type        = string
  description = "EKS vpc-cni addon version"
}

variable "eks_coredns_version" {
  type        = string
  description = "EKS coredns addon version"
}

variable "eks_kube_proxy_version" {
  type        = string
  description = "EKS kube-proxy addon version"
}

# TODO: rename after migration
variable "backend_integration_v2_alb_name" {
  description = ""
  type        = string
}

variable "eks_application_log_group_name" {
  description = "Name of the application log group created by FluentBit"
  type        = string
  default     = null
}

variable "dtd_share_sftp_hostname" {
  description = "Custom hostname for the DTD share SFTP server"
  type        = string
}

variable "k8s_monitoring_cronjobs_names" {
  description = "Names of K8s cronjobs to monitor"
  type        = list(string)
}
