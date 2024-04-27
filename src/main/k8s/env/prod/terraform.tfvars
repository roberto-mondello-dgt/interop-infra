aws_region = "eu-central-1"
env        = "prod"
app_name   = "interop"

tags = {
  CreatedBy   = "Terraform"
  Environment = "prod"
  Owner       = "PagoPA"
  Source      = "https://github.com/pagopa/interop-infra"
}

eks_cluster_name = "interop-eks-cluster-prod"
be_prefix        = "interop-be"

sso_full_admin_role_name = "AWSReservedSSO_FullAdmin_afdc92d80f0cc31a"
sso_readonly_role_name   = "AWSReservedSSO_ReadOnlyAccess_686bc134f666380d"

iac_k8s_readonly_role_name = "GitHubActionIACRoleReadOnly"

fargate_profiles_roles_names = ["Interop-EKS-SystemProfile", "Interop-EKS-ApplicationProfile", "Interop-EKS-ObservabilityProfile"]

k8s_admin_roles_names = ["GitHubActionIACRole", "interop-github-runner-task-prod"]

kube_state_metrics_image_version_tag = "v2.6.0"
kube_state_metrics_cpu               = "250m"
kube_state_metrics_memory            = "128Mi"

adot_collector_role_name = "adot-collector-prod"
adot_collector_image_uri = "amazon/aws-otel-collector:v0.30.0"

aws_load_balancer_controller_role_name = "aws-load-balancer-controller-prod"

enable_fluentbit_process_logs            = false
container_logs_cloudwatch_retention_days = 90

debezium_postgresql_image_uri               = "505630707203.dkr.ecr.eu-central-1.amazonaws.com/interop-debezium-postgresql:1.1.0"
debezium_postgresql_replicas                = 2
debezium_postgresql_cpu                     = "2"
debezium_postgresql_memory                  = "4Gi"
debezium_postgresql_role_name               = "interop-debezium-postgresql-prod"
debezium_postgresql_msk_cluster_arn         = "arn:aws:kafka:eu-central-1:697818730278:cluster/interop-events-prod/9b4ad8df-ffd5-4172-b2c0-85f13bb7e5b3-s2"
debezium_postgresql_aurora_cluster_id       = "interop-persistence-management-prod"
debezium_postgresql_database_name           = "persistence_management"
debezium_postgresql_credentials_secret_name = "persistence-management-debezium-credentials"
debezium_routing_partitions                 = 6
