aws_region = "eu-south-1"
env        = "qa"
app_name   = "interop"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Qa"
  Owner       = "Interoperabilità"
  CostCenter  = "TS620 Interoperabilità"
  Source      = "https://github.com/pagopa/interop-infra"
}

eks_cluster_name = "interop-eks-cluster-qa"
be_prefix        = "interop-be"

sso_full_admin_role_name = "AWSReservedSSO_FullAdmin_5dbb9b56c9f20407"
sso_readonly_role_name   = "AWSReservedSSO_ReadOnlyAccess_c77cc406e546953c"

iac_k8s_readonly_role_name = "GitHubActionIACRoleReadOnly"

fargate_profiles_roles_names = ["Interop-EKS-SystemProfile", "Interop-EKS-ApplicationProfile", "Interop-EKS-ObservabilityProfile"]

k8s_admin_roles_names = ["GitHubActionIACRole", "interop-github-runner-task-qa"]

kube_state_metrics_image_version_tag = "v2.6.0"
kube_state_metrics_cpu               = "250m"
kube_state_metrics_memory            = "128Mi"

adot_collector_role_name = "adot-collector-qa-es1"
adot_collector_image_uri = "amazon/aws-otel-collector:v0.39.1"

aws_load_balancer_controller_role_name = "aws-load-balancer-controller-qa-es1"

enable_fluentbit_process_logs            = false
container_logs_cloudwatch_retention_days = 30

debezium_postgresql_image_uri               = "505630707203.dkr.ecr.eu-south-1.amazonaws.com/interop-debezium-postgresql:1.1.0"
debezium_postgresql_replicas                = 1
debezium_postgresql_cpu                     = "2"
debezium_postgresql_memory                  = "4Gi"
debezium_postgresql_role_name               = "interop-debezium-postgresql-qa-es1"
debezium_postgresql_msk_cluster_arn         = "arn:aws:kafka:eu-south-1:755649575658:cluster/interop-platform-events-qa/185b388a-c94a-42a9-8167-a3797f265797-4"
debezium_postgresql_aurora_cluster_id       = "interop-platform-data-qa"
debezium_postgresql_database_name           = "persistence_management"
debezium_postgresql_credentials_secret_name = "platform-data-debezium-credentials"
debezium_routing_partitions                 = 3
