aws_region = "eu-central-1"
env        = "dev"
app_name   = "interop"

tags = {
  CreatedBy   = "Terraform"
  Environment = "dev"
  Owner       = "PagoPA"
  Source      = "https://github.com/pagopa/interop-infra"
}

eks_cluster_name = "interop-eks-cluster-dev"
be_prefix        = "interop-be"

sso_full_admin_role_name = "AWSReservedSSO_FullAdmin_51f0f6735b64a7f9"
sso_readonly_role_name   = "AWSReservedSSO_ReadOnlyAccess_c250df043035b7d7"

iac_k8s_readonly_role_name = "GitHubActionIACRoleReadOnly"

fargate_profiles_roles_names = ["Interop-EKS-SystemProfile", "Interop-EKS-ApplicationProfile", "Interop-EKS-ObservabilityProfile"]

k8s_admin_roles_names = ["GitHubActionIACRole", "interop-github-runner-task-dev"]

users_k8s_admin    = ["a.gallitano", "e.nardelli", "m.desimone", "r.castagnola"]
users_k8s_readonly = ["r.torsoli", "feda.abdallah"]

kube_state_metrics_image_version_tag = "v2.6.0"
kube_state_metrics_cpu               = "250m"
kube_state_metrics_memory            = "128Mi"

adot_collector_role_name = "adot-collector-dev"
adot_collector_image_uri = "amazon/aws-otel-collector:v0.30.0"

aws_load_balancer_controller_role_name = "aws-load-balancer-controller-dev"

enable_fluentbit_process_logs            = false
container_logs_cloudwatch_retention_days = 30

debezium_postgresql_image_uri               = "505630707203.dkr.ecr.eu-central-1.amazonaws.com/debezium-postgresql:latest"
debezium_postgresql_replicas                = 1
debezium_postgresql_cpu                     = "2"
debezium_postgresql_memory                  = "4Gi"
debezium_postgresql_role_name               = "interop-debezium-postgresql-dev"
debezium_postgresql_cluster_id              = "interop-persistence-management-dev"
debezium_postgresql_database_name           = "persistence_management_refactor"
debezium_postgresql_credentials_secret_name = "persistence-management-debezium-credentials"
