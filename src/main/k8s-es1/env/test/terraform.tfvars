aws_region = "eu-central-1"
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

k8s_admin_roles_names = ["GitHubActionIACRole", "interop-github-runner-task-test"]

users_k8s_admin = ["a.gallitano", "s.perazzolo", "a.gelameris", "e.nardelli", "m.desimone", "r.castagnola"]

kube_state_metrics_image_version_tag = "v2.6.0"
kube_state_metrics_cpu               = "250m"
kube_state_metrics_memory            = "128Mi"

adot_collector_role_name = "adot-collector-test"
adot_collector_image_uri = "amazon/aws-otel-collector:v0.39.1"

aws_load_balancer_controller_role_name = "aws-load-balancer-controller-test"

enable_fluentbit_process_logs            = false
container_logs_cloudwatch_retention_days = 30

debezium_postgresql_image_uri               = "505630707203.dkr.ecr.eu-central-1.amazonaws.com/interop-debezium-postgresql:1.1.0"
debezium_postgresql_replicas                = 1
debezium_postgresql_cpu                     = "2"
debezium_postgresql_memory                  = "4Gi"
debezium_postgresql_role_name               = "interop-debezium-postgresql-test"
debezium_postgresql_msk_cluster_arn         = "arn:aws:kafka:eu-central-1:895646477129:cluster/interop-events-test/725e7ccd-56e5-4444-b3eb-05d3e3302e9d-s2"
debezium_postgresql_aurora_cluster_id       = "interop-persistence-management-test"
debezium_postgresql_database_name           = "persistence_management"
debezium_postgresql_credentials_secret_name = "persistence-management-debezium-credentials"
debezium_routing_partitions                 = 3
