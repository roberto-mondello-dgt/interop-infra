aws_region = "eu-central-1"
env        = "att"
short_name = "interop"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Att"
  Owner       = "Interoperabilità"
  CostCenter  = "TS620 Interoperabilità"
  Source      = "https://github.com/pagopa/interop-infra"
}

sso_admin_role_name = "AWSReservedSSO_FullAdmin_b3727887a6d00b51"

bastion_host_ami_id        = "ami-094c442a8e9a67935"
bastion_host_instance_type = "t2.micro"
bastion_host_ssh_cidr      = "0.0.0.0/0"
bastion_host_key_pair      = "interop-bh-key-att"

persistence_management_database_name          = "persistence_management"
persistence_management_engine_version         = "13.9"
persistence_management_ca_cert_id             = "rds-ca-rsa2048-g1"
persistence_management_instance_class         = "db.t4g.medium"
persistence_management_number_instances       = 3
persistence_management_parameter_group_family = "aurora-postgresql13"
persistence_management_master_username        = "root"

read_model_cluster_id       = "read-model"
read_model_master_username  = "root"
read_model_engine_version   = "4.0.0"
read_model_instance_class   = "db.t4g.medium"
read_model_ca_cert_id       = "rds-ca-rsa2048-g1"
read_model_number_instances = 3

notification_events_table_ttl_enabled = true

github_runners_allowed_repos = ["pagopa/pdnd-interop-platform-deployment"]
github_runners_cpu           = 2048
github_runners_memory        = 4096
github_runners_image_uri     = "ghcr.io/pagopa/interop-github-runner-aws:v1.15.0"

dns_interop_base_domain = "interop.pagopa.it"

interop_frontend_assets_openapi_path = "./openapi/att/interop-frontend-assets-integrated.yaml"
interop_bff_openapi_path             = "./openapi/att/interop-backend-for-frontend-v1.0.yaml"
interop_auth_openapi_path            = "./openapi/att/interop-auth-server.yaml"
interop_api_openapi_path             = "./openapi/att/interop-api-v1.0.yaml"

interop_landing_domain_name = "att.interop.pagopa.it"

eks_k8s_version        = "1.29"
eks_vpc_cni_version    = "v1.16.0-eksbuild.1"
eks_coredns_version    = "v1.11.1-eksbuild.4"
eks_kube_proxy_version = "v1.29.0-eksbuild.1"

backend_integration_v2_alb_name = "k8s-interopbe-e364330a81"

eks_application_log_group_name = "/aws/eks/interop-eks-cluster-att/application"

# deployments which can be monitored using response HTTP status codes through APIGW
k8s_monitoring_deployments_names = [
  "interop-be-agreement-management",
  "interop-be-agreement-process",
  "interop-be-api-gateway",
  "interop-be-attribute-registry-management",
  "interop-be-attribute-registry-process",
  "interop-be-authorization-management",
  "interop-be-authorization-process",
  "interop-be-authorization-server",
  "interop-be-backend-for-frontend",
  "interop-be-catalog-management",
  "interop-be-catalog-process",
  "interop-be-notifier",
  "interop-be-party-registry-proxy",
  "interop-be-purpose-management",
  "interop-be-purpose-process",
  "interop-be-tenant-management",
  "interop-be-tenant-process",
  "interop-frontend",
]

# deployments which require monitoring from application logs instead of HTTP requests
k8s_monitoring_internal_deployments_names = [
  "interop-be-certified-mail-sender",
  "interop-be-selfcare-onboarding-consumer",
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
