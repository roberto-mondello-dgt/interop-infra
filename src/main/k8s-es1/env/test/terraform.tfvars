aws_region = "eu-south-1"
env        = "test"
app_name   = "interop"

tags = {
  CreatedBy   = "Terraform"
  Environment = "test"
  Owner       = "PagoPA"
  Source      = "https://github.com/pagopa/interop-infra"
}

eks_cluster_name = "interop-eks-cluster-test"
be_prefix        = "interop-be"

sso_full_admin_role_name = "AWSReservedSSO_FullAdmin_48811da36f58fc1e"
sso_readonly_role_name   = "AWSReservedSSO_ReadOnlyAccess_306c376a5a83bb31"

iac_k8s_readonly_role_name = "GitHubActionIACRoleReadOnly"

fargate_profiles_roles_names = ["Interop-EKS-SystemProfile", "Interop-EKS-ApplicationProfile", "Interop-EKS-ObservabilityProfile"]

k8s_admin_roles_names = ["GitHubActionIACRole", "interop-github-runner-task-test-es1"]

kube_state_metrics_image_version_tag = "v2.6.0"
kube_state_metrics_cpu               = "250m"
kube_state_metrics_memory            = "128Mi"

adot_collector_role_name = "adot-collector-test-es1"
adot_collector_image_uri = "amazon/aws-otel-collector:v0.39.1"

aws_load_balancer_controller_role_name = "aws-load-balancer-controller-test-es1"

enable_fluentbit_process_logs            = false
container_logs_cloudwatch_retention_days = 30

debezium_postgresql_image_uri               = "505630707203.dkr.ecr.eu-central-1.amazonaws.com/interop-debezium-postgresql:1.1.0"
debezium_postgresql_replicas                = 1
debezium_postgresql_cpu                     = "2"
debezium_postgresql_memory                  = "4Gi"
debezium_postgresql_role_name               = "interop-debezium-postgresql-test-es1"
debezium_postgresql_msk_cluster_arn         = "arn:aws:kafka:eu-south-1:895646477129:cluster/interop-platform-events-test/2952348f-d39d-47b2-925c-bd3edc78000c-3"
debezium_postgresql_aurora_cluster_id       = "interop-platform-data-test"
debezium_postgresql_database_name           = "persistence_management"
debezium_postgresql_credentials_secret_name = "platform-data-debezium-credentials"
debezium_routing_partitions                 = 3
