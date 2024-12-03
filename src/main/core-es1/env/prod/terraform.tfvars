aws_region = "eu-south-1"
env        = "prod"
short_name = "interop"
azs        = ["eu-south-1a", "eu-south-1b", "eu-south-1c"]

tags = {
  CreatedBy   = "Terraform"
  Environment = "prod"
  Owner       = "PagoPA"
  Source      = "https://github.com/pagopa/interop-infra"
}

sso_admin_role_name = "AWSReservedSSO_FullAdmin_afdc92d80f0cc31a"

bastion_host_ami_id              = "ami-05f5f4f906feab6a7"
bastion_host_instance_type       = "t2.micro"
bastion_host_private_ip          = "172.32.0.125"
bastion_host_security_group_name = "interop-bastion-host-prod-BastionSecurityGroup-RMFYSHUF0P69"
bastion_host_ssh_cidr            = "0.0.0.0/0"
bastion_host_key_pair            = "interop-bh-key-prod"

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
msk_signalhub_account_id   = "058264142001"

notification_events_table_ttl_enabled = true

backend_integration_alb_name = "k8s-interopbe-f2dce477db"

github_runners_allowed_repos = ["pagopa/pdnd-interop-platform-deployment"]
github_runners_cpu           = 2048
github_runners_memory        = 4096
github_runners_image_uri     = "ghcr.io/pagopa/interop-github-runner-aws:v1.15.0"

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

dns_interop_qa_ns_records = [
  "ns-1566.awsdns-03.co.uk.",
  "ns-719.awsdns-25.net.",
  "ns-473.awsdns-59.com.",
  "ns-1437.awsdns-51.org."
]

dns_interop_att_ns_records = [
  "ns-1788.awsdns-31.co.uk.",
  "ns-633.awsdns-15.net.",
  "ns-28.awsdns-03.com.",
  "ns-1174.awsdns-18.org."
]

signalhub_domain_ns_records = [
  "ns-2046.awsdns-63.co.uk.",
  "ns-230.awsdns-28.com.",
  "ns-1452.awsdns-53.org.",
  "ns-917.awsdns-50.net."
]

tracing_domain_ns_records = [
  "ns-1684.awsdns-18.co.uk.",
  "ns-1285.awsdns-32.org.",
  "ns-549.awsdns-04.net.",
  "ns-405.awsdns-50.com."
]

data_lake_account_id            = "688071769384"
data_lake_external_id           = "2d1cd942-284f-4448-a8f0-2aa403b064b1"
data_lake_interfaces_bucket_arn = "arn:aws:s3:::pdnd-prod-dl-1"

interop_frontend_assets_openapi_path = "./openapi/prod/interop-frontend-assets-integrated.yaml"
interop_bff_proxy_openapi_path       = "./openapi/interop-backend-for-frontend-proxy.yaml"
interop_bff_openapi_path             = "./openapi/interop-backend-for-frontend-proxy.yaml"
interop_auth_openapi_path            = "./openapi/prod/interop-auth-server.yaml"
interop_api_openapi_path             = "./openapi/prod/interop-api-v1.0.yaml"

interop_landing_domain_name = "interop.pagopa.it"

lambda_eks_application_log_group_arn = "arn:aws:logs:eu-central-1:697818730278:log-group:/aws/eks/interop-eks-prod/application:*"

eks_k8s_version        = "1.29"
eks_vpc_cni_version    = "v1.16.0-eksbuild.1"
eks_coredns_version    = "v1.11.1-eksbuild.4"
eks_kube_proxy_version = "v1.29.0-eksbuild.1"

backend_integration_v2_alb_name = "k8s-interopbe-f2dce477db"

eks_application_log_group_name = "/aws/eks/interop-eks-cluster-prod/application"

dtd_share_sftp_hostname = "dtd-share.interop.pagopa.it"

vpn_saml_metadata_path = "./assets/saml-metadata/interop-vpn-saml-prod.xml"

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
  "interop-be-delegation-process",
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
  "interop-be-datalake-interface-exporter",
  "interop-be-delegation-readmodel-writer",
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
