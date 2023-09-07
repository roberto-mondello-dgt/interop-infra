aws_region = "eu-central-1"
env        = "test"
short_name = "interop"

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
read_model_number_instances     = 3
read_model_subnet_group_name    = "docdbsubnetgroup-obcnimrvqtxx"
read_model_parameter_group_name = "read-model-parameter-group"

notification_events_table_ttl_enabled = true

backend_integration_alb_name = "k8s-interopbe-d20020e3b0"

github_runners_allowed_repos = ["pagopa/pdnd-interop-platform-deployment"]
github_runners_cpu           = 2048
github_runners_memory        = 4096
github_runners_image_uri     = "ghcr.io/pagopa/interop-github-runner-aws:v1.10.0"

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

interop_auth_openapi_path = "./openapi/test/auth-server/interop-auth-server-adc891fab798b0da9fd9990d686e97c3ee6493ff.yaml"
interop_api_openapi_path  = "./openapi/test/internal-api-gateway/interop-api-v1.0-d3dfe1725cee1cac81b6b34d8746b71e93598b15.yaml"

interop_landing_domain_name = "uat.interop.pagopa.it"

lambda_eks_application_log_group_arn = "arn:aws:logs:eu-central-1:895646477129:log-group:/aws/eks/interop-eks-test/application:*"

eks_k8s_version        = "1.26"
eks_vpc_cni_version    = "v1.12.6-eksbuild.1"
eks_coredns_version    = "v1.9.3-eksbuild.3"
eks_kube_proxy_version = "v1.26.2-eksbuild.1"

backend_integration_v2_alb_name = "k8s-interopbe-d20020e3b0"

eks_application_log_group_name = "/aws/eks/interop-eks-cluster-test/application"

dtd_share_sftp_hostname = "dtd-share.uat.interop.pagopa.it"

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
  "redis"
]

k8s_monitoring_cronjobs_names = [
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
