aws_region = "eu-south-1"
env        = "qa"
short_name = "interop"
azs        = ["eu-south-1a", "eu-south-1b", "eu-south-1c"]

tags = {
  CreatedBy   = "Terraform"
  Environment = "Qa"
  Owner       = "Interoperabilità"
  CostCenter  = "TS620 Interoperabilità"
  Source      = "https://github.com/pagopa/interop-infra"
}

sso_admin_role_name = "AWSReservedSSO_FullAdmin_5dbb9b56c9f20407"

bastion_host_ami_id        = "ami-094c442a8e9a67935"
bastion_host_instance_type = "t2.micro"
bastion_host_ssh_cidr      = "0.0.0.0/0"
bastion_host_key_pair      = "interop-bh-key-qa"

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
read_model_instance_class   = "db.t4g.medium"
read_model_ca_cert_id       = "rds-ca-rsa2048-g1"
read_model_number_instances = 3

msk_version                = "3.6.0"
msk_number_azs             = 3
msk_number_brokers         = 3
msk_brokers_instance_class = "kafka.m5.large"
msk_brokers_storage_gib    = 100
msk_signalhub_account_id   = "058264553932"

notification_events_table_ttl_enabled = true

github_runners_allowed_repos = ["pagopa/pdnd-interop-platform-deployment", "pagopa/interop-qa-development", "pagopa/interop-qa-tests"]
github_runners_cpu           = 2048
github_runners_memory        = 4096
github_runners_image_uri     = "ghcr.io/pagopa/interop-github-runner-aws:v1.15.0"

dns_interop_base_domain = "interop.pagopa.it"

interop_frontend_assets_openapi_path = "./openapi/qa/interop-frontend-assets-integrated.yaml"
interop_bff_proxy_openapi_path       = "./openapi/interop-backend-for-frontend-proxy.yaml"
interop_bff_openapi_path             = "./openapi/interop-backend-for-frontend-proxy.yaml"
interop_auth_openapi_path            = "./openapi/qa/interop-auth-server.yaml"
interop_api_openapi_path             = "./openapi/qa/interop-api-v1.0.yaml"

interop_landing_domain_name = "qa.interop.pagopa.it"

eks_k8s_version        = "1.29"
eks_vpc_cni_version    = "v1.16.0-eksbuild.1"
eks_coredns_version    = "v1.11.1-eksbuild.4"
eks_kube_proxy_version = "v1.29.0-eksbuild.1"

backend_integration_alb_name = "k8s-interopbe-e296f81b2b"

eks_application_log_group_name = "/aws/eks/interop-eks-cluster-qa/application"

# deployments which can be monitored using response HTTP status codes through APIGW
k8s_monitoring_deployments_names = [
  "interop-be-agreement-process",
  "interop-be-api-gateway",
  "interop-be-attribute-registry-process",
  "interop-be-authorization-management",
  "interop-be-authorization-process",
  "interop-be-authorization-server",
  "interop-be-backend-for-frontend",
  "interop-be-catalog-process",
  "interop-be-delegation-process",
  "interop-be-notifier",
  "interop-be-party-registry-proxy",
  "interop-be-purpose-process",
  "interop-be-tenant-process",
  "interop-frontend"
]

# deployments which require monitoring from application logs instead of HTTP requests
k8s_monitoring_internal_deployments_names = [
  "debezium-postgresql",
  "interop-be-agreement-email-sender",
  "interop-be-agreement-platformstate-writer",
  "interop-be-agreement-readmodel-writer",
  "interop-be-attribute-registry-readmodel-writer",
  "interop-be-authorization-platformstate-writer",
  "interop-be-authorization-updater",
  "interop-be-catalog-platformstate-writer",
  "interop-be-catalog-readmodel-writer",
  "interop-be-certified-email-sender",
  "interop-be-client-purpose-updater",
  "interop-be-compute-agreements-consumer",
  "interop-be-datalake-interface-exporter",
  "interop-be-delegation-readmodel-writer",
  "interop-be-eservice-descriptors-archiver",
  "interop-be-eservice-template-process",
  "interop-be-eservice-template-readmodel-writer",
  "interop-be-eservice-template-updater",
  "interop-be-notification-email-sender",
  "interop-be-notifier",
  "interop-be-notifier-seeder",
  "interop-be-purpose-platformstate-writer",
  "interop-be-purpose-readmodel-writer",
  "interop-be-selfcare-onboarding-consumer",
  "interop-be-tenant-readmodel-writer",
  "redis"
]

k8s_monitoring_cronjobs_names = [
  "interop-be-anac-certified-attributes-importer",
  "interop-be-attributes-loader",
  "interop-be-dashboard-metrics-report-generator",
  "interop-be-datalake-data-export",
  "interop-be-dtd-catalog-exporter",
  "interop-be-dtd-catalog-total-load-exporter",
  "interop-be-dtd-metrics",
  "interop-be-eservices-monitoring-exporter",
  "interop-be-ivass-certified-attributes-importer",
  "interop-be-metrics-report-generator",
  "interop-be-one-trust-notices",
  "interop-be-padigitale-report-generator",
  "interop-be-party-registry-proxy-refresher",
  "interop-be-pn-consumers",
  "interop-be-tenants-cert-attr-updater",
  "interop-be-token-details-persister"
]

deployment_repo_name = "pagopa/interop-core-deployment"
