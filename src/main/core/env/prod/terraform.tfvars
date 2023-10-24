aws_region = "eu-central-1"
env        = "prod"
short_name = "interop"

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

eks_cluster_name = "interop-eks-prod"

persistence_management_cluster_id             = "interop-rds-prod-auroradbcluster-n6mrmtikvktv"
persistence_management_database_name          = "persistence_management"
persistence_management_engine_version         = "13.9"
persistence_management_ca_cert_id             = "rds-ca-rsa2048-g1"
persistence_management_instance_class         = "db.t4g.medium"
persistence_management_number_instances       = 3
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
read_model_number_instances     = 3
read_model_subnet_group_name    = "docdbsubnetgroup-o9tsiei6mmwh"
read_model_parameter_group_name = "read-model-parameter-group"

notification_events_table_ttl_enabled = true

backend_integration_alb_name = "k8s-interopbe-f2dce477db"

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
interop_api_openapi_path  = "./openapi/prod/internal-api-gateway/interop-api-v1.0-316e901f76e444ce898a6b087780efa2d51c3cf8.yaml"

interop_landing_domain_name = "interop.pagopa.it"

lambda_eks_application_log_group_arn = "arn:aws:logs:eu-central-1:697818730278:log-group:/aws/eks/interop-eks-prod/application:*"

eks_k8s_version        = "1.26"
eks_vpc_cni_version    = "v1.12.6-eksbuild.1"
eks_coredns_version    = "v1.9.3-eksbuild.3"
eks_kube_proxy_version = "v1.26.2-eksbuild.1"

backend_integration_v2_alb_name = "k8s-interopbe-f2dce477db"

eks_application_log_group_name = "/aws/eks/interop-eks-cluster-prod/application"

dtd_share_sftp_hostname = "dtd-share.interop.pagopa.it"

vpn_saml_metadata_path = "./assets/saml-metadata/interop-vpn-saml-prod.xml"

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
  "interop-be-dtd-catalog-exporter",
  "interop-be-dtd-metrics",
  "interop-be-eservices-monitoring-exporter",
  "interop-be-metrics-report-generator",
  "interop-be-one-trust-notices",
  "interop-be-padigitale-report-generator",
  "interop-be-party-registry-proxy-refresher",
  "interop-be-pn-consumers",
  "interop-be-tenants-cert-attr-updater",
  "interop-be-token-details-persister"
]
