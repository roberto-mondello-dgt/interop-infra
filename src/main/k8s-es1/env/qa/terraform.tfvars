aws_region = "eu-central-1"
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

sso_full_admin_role_name = "AWSReservedSSO_FullAdmin_5dbb9b56c9f20407 "
sso_readonly_role_name   = "AWSReservedSSO_ReadOnlyAccess_c77cc406e546953c "

iac_k8s_readonly_role_name = "GitHubActionIACRoleReadOnly"

fargate_profiles_roles_names = ["Interop-EKS-SystemProfile", "Interop-EKS-ApplicationProfile", "Interop-EKS-ObservabilityProfile"]

k8s_admin_roles_names = ["GitHubActionIACRole", "interop-github-runner-task-qa"]

users_k8s_admin = ["manuel.morini"]

kube_state_metrics_image_version_tag = "v2.6.0"
kube_state_metrics_cpu               = "250m"
kube_state_metrics_memory            = "128Mi"

adot_collector_role_name = "adot-collector-qa"
adot_collector_image_uri = "amazon/aws-otel-collector:v0.39.1"

aws_load_balancer_controller_role_name = "aws-load-balancer-controller-qa"

enable_fluentbit_process_logs            = false
container_logs_cloudwatch_retention_days = 30

debezium_postgresql_image_uri               = "505630707203.dkr.ecr.eu-central-1.amazonaws.com/interop-debezium-postgresql:1.1.0"
debezium_postgresql_replicas                = 1
debezium_postgresql_cpu                     = "2"
debezium_postgresql_memory                  = "4Gi"
debezium_postgresql_role_name               = "interop-debezium-postgresql-qa"
debezium_postgresql_msk_cluster_arn         = "arn:aws:kafka:eu-central-1:755649575658:cluster/interop-events-qa/0c185564-4175-445c-a74d-3c0e6ce324a1-s2"
debezium_postgresql_aurora_cluster_id       = "interop-persistence-management-qa"
debezium_postgresql_database_name           = "persistence_management"
debezium_postgresql_credentials_secret_name = "persistence-management-debezium-credentials"
debezium_routing_partitions                 = 3
