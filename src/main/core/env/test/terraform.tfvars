aws_region = "eu-central-1"
env        = "test"
short_name = "interop"

tags = {
  CreatedBy   = "Terraform"
  Environment = "test"
  Owner       = "PagoPA"
  Source      = "https://github.com/pagopa/interop-infra"
}

bastion_host_ami_id              = "ami-05f5f4f906feab6a7"
bastion_host_instance_type       = "t2.micro"
bastion_host_private_ip          = "172.32.0.102"
bastion_host_security_group_name = "interop-bastion-host-test-BastionSecurityGroup-1KAJGE4ZLTG1X"
bastion_host_ssh_cidr            = "0.0.0.0/0"
bastion_host_key_pair            = "interop-bh-key"

eks_cluster_name = "interop-eks-test"

persistence_management_cluster_id             = "interop-rds-test-auroradbcluster-u2a45bkp2iqr"
persistence_management_database_name          = "persistence_management"
persistence_management_engine_version         = "13.4"
persistence_management_instance_class         = "db.t4g.large"
persistence_management_subnet_group_name      = "interop-rds-test-dbsubnetgroup-ex5iby3uhnbt"
persistence_management_parameter_group_name   = "interop-rds-test-rdsdbclusterparametergroup-y0wcfjbgv5fy"
persistence_management_parameter_group_family = "aurora-postgresql13"
persistence_management_master_username        = "root"
persistence_management_primary_instance_id    = "iamjt69lstx8vp"
persistence_management_replica1_instance_id   = "ia2kfif199v3bk"
persistence_management_replica2_instance_id   = "ia5op8xj5o25hp"

read_model_cluster_id           = "read-model"
read_model_master_username      = "root"
read_model_engine_version       = "4.0.0"
read_model_instance_class       = "db.t4g.medium"
read_model_subnet_group_name    = "docdbsubnetgroup-obcnimrvqtxx"
read_model_parameter_group_name = "read-model-parameter-group"

notification_events_table_ttl_enabled = true

backend_integration_alb_name = "k8s-test-interops-1810b960f8"
