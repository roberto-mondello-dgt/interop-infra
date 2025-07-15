aws_region = "eu-south-1"
env        = "dev"
short_name = "interop"
azs        = ["eu-south-1a", "eu-south-1b", "eu-south-1c"]

tags = {
  CreatedBy   = "Terraform"
  Environment = "dev"
  Owner       = "PagoPA"
  Source      = "https://github.com/pagopa/interop-infra"
}

sso_admin_role_name = "AWSReservedSSO_FullAdmin_51f0f6735b64a7f9"

bastion_host_ami_id        = "ami-094c442a8e9a67935"
bastion_host_instance_type = "t2.micro"
bastion_host_key_pair      = "interop-bh-key-dev"

platform_data_database_name          = "persistence_management"
platform_data_engine_version         = "13.11"
platform_data_ca_cert_id             = "rds-ca-rsa2048-g1"
platform_data_instance_class         = "db.r6g.large"
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
msk_signalhub_account_id   = "058264553932"
msk_tracing_account_id     = "590183909663"
msk_probing_account_id     = "774300547186"

notification_events_table_ttl_enabled = true

github_runners_allowed_repos = [
  "pagopa/pdnd-interop-platform-deployment",
  "pagopa/interop-platform-deployment-refactor",
  "pagopa/interop-github-runner-aws",
  "pagopa/interop-qa-tests",
  "pagopa/interop-analytics-deployment",
  "pagopa/interop-core-deployment"
]
github_runners_cpu       = 2048
github_runners_memory    = 4096
github_runners_image_uri = "ghcr.io/pagopa/interop-github-runner-aws:v1.19.0"

dns_interop_base_domain = "interop.pagopa.it"

data_lake_account_id            = "688071769384"
data_lake_external_id           = "ac94a267-b8fc-4ecc-8294-8302795e8ba3"
data_lake_interfaces_bucket_arn = "arn:aws:s3:::pdnd-prod-dl-1"

probing_registry_reader_role_arn = "arn:aws:iam::774300547186:role/application/eks/pods/interop-be-probing-registry-reader-dev"
probing_domain_ns_records = [
  "ns-1122.awsdns-12.org",
  "ns-1665.awsdns-16.co.uk",
  "ns-272.awsdns-34.com",
  "ns-826.awsdns-39.net",
]

interop_frontend_assets_openapi_path = "./openapi/dev/interop-frontend-assets-integrated.yaml"
interop_bff_proxy_openapi_path       = "./openapi/interop-backend-for-frontend-proxy.yaml"
interop_bff_openapi_path             = "./openapi/dev/interop-backend-for-frontend-v1.0.yaml"
interop_auth_openapi_path            = "./openapi/dev/interop-auth-server.yaml"
interop_api_openapi_path             = "./openapi/dev/interop-api-v1.0.yaml"
interop_api_v2_openapi_path          = "./openapi/dev/interop-api-v2.yaml"

interop_landing_domain_name = "dev.interop.pagopa.it"

eks_k8s_version = "1.32"

backend_integration_alb_name = "k8s-interopbe-2e63f79573"

eks_application_log_group_name = "/aws/eks/interop-eks-cluster-dev/application"

# (dev NS) deployments which require monitoring from application logs instead of HTTP requests
k8s_monitoring_internal_deployments_names = [
  "debezium-postgresql",
]

# (dev-refactor NS) deployments which require monitoring from application logs instead of HTTP requests
be_refactor_k8s_monitoring_internal_deployments_names = [
  "debezium-postgresql",
]

deployment_repo_name = "pagopa/interop-core-deployment"

analytics_k8s_namespace = "dev-analytics"
