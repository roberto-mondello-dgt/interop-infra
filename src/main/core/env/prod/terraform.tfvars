aws_region = "eu-central-1"
env        = "prod"
short_name = "interop"

tags = {
  CreatedBy   = "Terraform"
  Environment = "prod"
  Owner       = "PagoPA"
  Source      = "https://github.com/pagopa/interop-infra"
}

bastion_host_ami_id              = "ami-05f5f4f906feab6a7"
bastion_host_instance_type       = "t2.micro"
bastion_host_private_ip          = "172.32.0.125"
bastion_host_security_group_name = "interop-bastion-host-prod-BastionSecurityGroup-RMFYSHUF0P69"
bastion_host_ssh_cidr            = "0.0.0.0/0"
bastion_host_key_pair            = "interop-bh-key-prod"

eks_cluster_name = "interop-eks-prod"

persistence_management_cluster_id             = "interop-rds-prod-auroradbcluster-n6mrmtikvktv"
persistence_management_database_name          = "persistence_management"
persistence_management_engine_version         = "13.9"
persistence_management_instance_class         = "db.t4g.medium"
persistence_management_subnet_group_name      = "interop-rds-prod-dbsubnetgroup-wtgcr8luwouy"
persistence_management_parameter_group_name   = "interop-rds-prod-rdsdbclusterparametergroup-jccxnxbx76wj"
persistence_management_parameter_group_family = "aurora-postgresql13"
persistence_management_master_username        = "root"
persistence_management_primary_instance_id    = "iacssmqzaqjtke"
persistence_management_replica1_instance_id   = "iag1ir56gge28j"
persistence_management_replica2_instance_id   = "iai6ggc9mqc8df"

read_model_cluster_id           = "read-model"
read_model_master_username      = "root"
read_model_engine_version       = "4.0.0"
read_model_instance_class       = "db.t4g.medium"
read_model_subnet_group_name    = "docdbsubnetgroup-o9tsiei6mmwh"
read_model_parameter_group_name = "read-model-parameter-group"

notification_events_table_ttl_enabled = true

backend_integration_alb_name = "k8s-prod-interops-18ff9f336d"

github_runners_allowed_repos = ["pagopa/pdnd-interop-platform-deployment"]
github_runners_cpu           = 2048
github_runners_memory        = 4096
github_runners_image_uri     = "ghcr.io/pagopa/interop-github-runner-aws:v1.10.0"

dns_interop_base_domain = "interop.pagopa.it"
dns_interop_dev_ns_records = [
  "ns-1337.awsdns-39.org.",
  "ns-70.awsdns-08.com.",
  "ns-1728.awsdns-24.co.uk.",
  "ns-876.awsdns-45.net.",
]
dns_interop_uat_ns_records = [
  "ns-1942.awsdns-50.co.uk.",
  "ns-783.awsdns-33.net.",
  "ns-317.awsdns-39.com.",
  "ns-1395.awsdns-46.org.",
]

data_lake_account_id  = "688071769384"
data_lake_external_id = "2d1cd942-284f-4448-a8f0-2aa403b064b1"

interop_auth_openapi_path = "./openapi/prod/auth-server/interop-auth-server-adc891fab798b0da9fd9990d686e97c3ee6493ff.yaml"
interop_api_openapi_path  = "./openapi/prod/internal-api-gateway/interop-api-v1.0-04797574cb3dfc89d34f7f2b328a1048c5b21ee5.yaml"
