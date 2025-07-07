aws_region = "eu-south-1"
env        = "test"
short_name = "interop"
azs        = ["eu-south-1a", "eu-south-1b", "eu-south-1c"]

tags = {
  CreatedBy   = "Terraform"
  Environment = "test"
  Owner       = "PagoPA"
  Source      = "https://github.com/pagopa/interop-infra"
}

sso_admin_role_name = "AWSReservedSSO_FullAdmin_48811da36f58fc1e"

bastion_host_ami_id        = "ami-05f5f4f906feab6a7"
bastion_host_instance_type = "t2.micro"
bastion_host_key_pair      = "interop-bh-key"

platform_data_database_name          = "persistence_management"
platform_data_engine_version         = "13.9"
platform_data_ca_cert_id             = "rds-ca-rsa2048-g1"
platform_data_instance_class         = "db.t4g.medium"
platform_data_number_instances       = 3
platform_data_parameter_group_family = "aurora-postgresql13"
platform_data_master_username        = "root"

read_model_cluster_id       = "read-model"
read_model_master_username  = "root"
read_model_engine_version   = "4.0.0"
read_model_instance_class   = "db.r6g.large"
read_model_ca_cert_id       = "rds-ca-rsa2048-g1"
read_model_number_instances = 3

msk_version                = "3.6.0"
msk_number_azs             = 3
msk_number_brokers         = 3
msk_brokers_instance_class = "kafka.m5.large"
msk_brokers_storage_gib    = 100
msk_signalhub_account_id   = "654654262692"
msk_tracing_account_id     = "637423185147"

notification_events_table_ttl_enabled = true

backend_integration_alb_name = "k8s-interopbe-d20020e3b0"

github_runners_allowed_repos = ["pagopa/pdnd-interop-platform-deployment", "pagopa/interop-core-deployment"]
github_runners_cpu           = 2048
github_runners_memory        = 4096
github_runners_image_uri     = "ghcr.io/pagopa/interop-github-runner-aws:v1.18.1"

dns_interop_base_domain = "interop.pagopa.it"

data_lake_account_id            = "688071769384"
data_lake_external_id           = "e6383ad7-ca3e-441e-9220-ecc45869b58a"
data_lake_interfaces_bucket_arn = "arn:aws:s3:::pdnd-prod-dl-1"

probing_registry_reader_role_arn = "arn:aws:iam::010158505074:role/application/eks/pods/interop-be-probing-registry-reader-uat"
probing_domain_ns_records = [
  "ns-1332.awsdns-38.org",
  "ns-1645.awsdns-13.co.uk",
  "ns-463.awsdns-57.com",
  "ns-913.awsdns-50.net"
]

interop_frontend_assets_openapi_path = "./openapi/test/interop-frontend-assets-integrated.yaml"
interop_bff_proxy_openapi_path       = "./openapi/interop-backend-for-frontend-proxy.yaml"
interop_bff_openapi_path             = "./openapi/interop-backend-for-frontend-proxy.yaml"
interop_auth_openapi_path            = "./openapi/test/interop-auth-server.yaml"
interop_api_openapi_path             = "./openapi/test/interop-api-v1.0.yaml"
interop_api_v2_openapi_path          = "./openapi/test/interop-api-v2.yaml"

interop_landing_domain_name = "uat.interop.pagopa.it"

lambda_eks_application_log_group_arn = "arn:aws:logs:eu-central-1:895646477129:log-group:/aws/eks/interop-eks-test/application:*"

eks_k8s_version = "1.32"

backend_integration_v2_alb_name = "k8s-interopbe-d20020e3b0"

eks_application_log_group_name = "/aws/eks/interop-eks-cluster-test/application"

safe_storage_account_id        = "891377202032"
safe_storage_vpce_service_name = "com.amazonaws.vpce.eu-south-1.vpce-svc-075ebde4859d4c631"

# deployments which require monitoring from application logs instead of HTTP requests
k8s_monitoring_internal_deployments_names = [
  "debezium-postgresql"
]

deployment_repo_name = "pagopa/interop-core-deployment"
