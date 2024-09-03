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

bastion_host_ami_id              = "ami-05f5f4f906feab6a7"
bastion_host_instance_type       = "t2.micro"
bastion_host_private_ip          = "172.32.0.102"
bastion_host_security_group_name = "interop-bastion-host-test-BastionSecurityGroup-1KAJGE4ZLTG1X"
bastion_host_ssh_cidr            = "0.0.0.0/0"
bastion_host_key_pair            = "interop-bh-key"

eks_cluster_name = "interop-eks-test"

persistence_management_cluster_id             = "interop-rds-test-auroradbcluster-u2a45bkp2iqr"
persistence_management_database_name          = "persistence_management"
persistence_management_engine_version         = "13.9"
persistence_management_ca_cert_id             = "rds-ca-rsa2048-g1"
persistence_management_instance_class         = "db.t4g.large"
persistence_management_number_instances       = 3
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
read_model_ca_cert_id           = "rds-ca-rsa2048-g1"
read_model_number_instances     = 3
read_model_subnet_group_name    = "docdbsubnetgroup-obcnimrvqtxx"
read_model_parameter_group_name = "read-model-parameter-group"

notification_events_table_ttl_enabled = true

backend_integration_alb_name = "k8s-interopbe-d20020e3b0"

github_runners_allowed_repos = ["pagopa/pdnd-interop-platform-deployment"]
github_runners_cpu           = 2048
github_runners_memory        = 4096
github_runners_image_uri     = "ghcr.io/pagopa/interop-github-runner-aws:v1.15.0"

dns_interop_base_domain = "interop.pagopa.it"

data_lake_account_id  = "688071769384"
data_lake_external_id = "e6383ad7-ca3e-441e-9220-ecc45869b58a"

probing_registry_reader_role_arn = "arn:aws:iam::010158505074:role/application/eks/pods/interop-be-probing-registry-reader-uat"
probing_domain_ns_records = [
  "ns-1332.awsdns-38.org",
  "ns-1645.awsdns-13.co.uk",
  "ns-463.awsdns-57.com",
  "ns-913.awsdns-50.net"
]

interop_frontend_assets_openapi_path = "./openapi/test/interop-frontend-assets-integrated.yaml"
interop_bff_proxy_openapi_path       = "./openapi/interop-backend-for-frontend-proxy.yaml"
interop_bff_openapi_path             = "./openapi/test/interop-backend-for-frontend-v1.0.yaml"
interop_auth_openapi_path            = "./openapi/test/interop-auth-server.yaml"
interop_api_openapi_path             = "./openapi/test/interop-api-v1.0.yaml"

interop_landing_domain_name = "uat.interop.pagopa.it"

lambda_eks_application_log_group_arn = "arn:aws:logs:eu-central-1:895646477129:log-group:/aws/eks/interop-eks-test/application:*"

eks_k8s_version        = "1.26"
eks_vpc_cni_version    = "v1.12.6-eksbuild.1"
eks_coredns_version    = "v1.9.3-eksbuild.3"
eks_kube_proxy_version = "v1.26.2-eksbuild.1"

backend_integration_v2_alb_name = "k8s-interopbe-d20020e3b0"

eks_application_log_group_name = "/aws/eks/interop-eks-cluster-test/application"

safe_storage_vpce_service_name = "com.amazonaws.vpce.eu-south-1.vpce-svc-075ebde4859d4c631"

# deployments which can be monitored using response HTTP status codes through APIGW
k8s_monitoring_deployments_names = [
  "interop-be-agreement-management",
  "interop-be-agreement-process",
  "interop-be-api-gateway",
  "interop-be-attribute-registry-process",
  "interop-be-authorization-management",
  "interop-be-authorization-process",
  "interop-be-authorization-server",
  "interop-be-backend-for-frontend",
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
  "debezium-postgresql",
  "interop-be-agreement-email-sender",
  "interop-be-agreement-readmodel-writer",
  "interop-be-attribute-registry-readmodel-writer",
  "interop-be-authorization-updater",
  "interop-be-catalog-readmodel-writer",
  "interop-be-certified-mail-sender",
  "interop-be-compute-agreements-consumer",
  "interop-be-eservice-descriptors-archiver",
  "interop-be-notifier",
  "interop-be-notifier-seeder",
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
