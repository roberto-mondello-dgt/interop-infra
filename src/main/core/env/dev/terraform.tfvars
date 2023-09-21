aws_region = "eu-central-1"
env        = "dev"
short_name = "interop"

tags = {
  CreatedBy   = "Terraform"
  Environment = "dev"
  Owner       = "PagoPA"
  Source      = "https://github.com/pagopa/interop-infra"
}

sso_admin_role_name = "AWSReservedSSO_FullAdmin_51f0f6735b64a7f9"

bastion_host_ami_id              = "ami-094c442a8e9a67935"
bastion_host_instance_type       = "t2.micro"
bastion_host_private_ip          = "172.32.0.7"
bastion_host_security_group_name = "interop-bastion-host-dev-BastionSecurityGroup-WP1X6VLMIUMW"
bastion_host_ssh_cidr            = "0.0.0.0/0"
bastion_host_key_pair            = "interop-bh-key-dev"

eks_cluster_name = "interop-eks-dev"

persistence_management_cluster_id             = "interop-rds-dev-auroradbcluster-1ws49gkll6459"
persistence_management_database_name          = "persistence_management"
persistence_management_engine_version         = "13.9"
persistence_management_ca_cert_id             = "rds-ca-rsa2048-g1"
persistence_management_instance_class         = "db.t4g.medium"
persistence_management_number_instances       = 3
persistence_management_subnet_group_name      = "interop-rds-dev-dbsubnetgroup-fk3mnuj6th50"
persistence_management_parameter_group_name   = "interop-rds-dev-rdsdbclusterparametergroup-pmkjrep8gv9p"
persistence_management_parameter_group_family = "aurora-postgresql13"
persistence_management_master_username        = "root"
persistence_management_primary_instance_id    = "iaf29k8l5z7a59"
persistence_management_replica1_instance_id   = "ia191bvain9ri2q"
persistence_management_replica2_instance_id   = "iacgbfxq3g2q6b"

read_model_cluster_id           = "read-model"
read_model_master_username      = "root"
read_model_engine_version       = "4.0.0"
read_model_instance_class       = "db.t4g.medium"
read_model_number_instances     = 3
read_model_subnet_group_name    = "docdbsubnetgroup-juvy8znmt1bi"
read_model_parameter_group_name = "read-model-parameter-group"

notification_events_table_ttl_enabled = true

backend_integration_alb_name = "k8s-interopbe-2e63f79573"

github_runners_allowed_repos = ["pagopa/pdnd-interop-platform-deployment", "pagopa/interop-github-runner-aws"]
github_runners_cpu           = 2048
github_runners_memory        = 4096
github_runners_image_uri     = "ghcr.io/pagopa/interop-github-runner-aws:v1.10.0"

dns_interop_base_domain = "interop.pagopa.it"

data_lake_account_id  = "688071769384"
data_lake_external_id = "ac94a267-b8fc-4ecc-8294-8302795e8ba3"

probing_registry_reader_role_arn = "arn:aws:iam::774300547186:role/application/eks/pods/interop-be-probing-registry-reader-dev"
probing_domain_ns_records = [
  "ns-1122.awsdns-12.org",
  "ns-1665.awsdns-16.co.uk",
  "ns-272.awsdns-34.com",
  "ns-826.awsdns-39.net",
]

interop_auth_openapi_path = "./openapi/dev/auth-server/interop-auth-server-adc891fab798b0da9fd9990d686e97c3ee6493ff.yaml"
interop_api_openapi_path  = "./openapi/dev/internal-api-gateway/interop-api-v1.0-d3dfe1725cee1cac81b6b34d8746b71e93598b15.yaml"

interop_landing_domain_name = "dev.interop.pagopa.it"

lambda_eks_application_log_group_arn = "arn:aws:logs:eu-central-1:505630707203:log-group:/aws/eks/interop-eks-dev/application:*"

eks_k8s_version        = "1.26"
eks_vpc_cni_version    = "v1.12.6-eksbuild.1"
eks_coredns_version    = "v1.9.3-eksbuild.3"
eks_kube_proxy_version = "v1.26.2-eksbuild.1"

backend_integration_v2_alb_name = "k8s-interopbe-2e63f79573"

eks_application_log_group_name = "/aws/eks/interop-eks-cluster-dev/application"

dtd_share_sftp_hostname = "dtd-share.dev.interop.pagopa.it"

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
