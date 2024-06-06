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

fargate_profiles_roles_names = ["Interop-EKS-SystemProfile", "Interop-EKS-ApplicationProfile", "Interop-EKS-ObservabilityProfile"]

kube_state_metrics_image_version_tag = "v2.6.0"
kube_state_metrics_cpu               = "250m"
kube_state_metrics_memory            = "128Mi"

adot_collector_role_name = "adot-collector-dev"
adot_collector_image_uri = "amazon/aws-otel-collector:v0.30.0"

aws_load_balancer_controller_role_name = "aws-load-balancer-controller-dev"

enable_fluentbit_process_logs            = false
container_logs_cloudwatch_retention_days = 30

debezium_postgresql_image_uri               = "505630707203.dkr.ecr.eu-central-1.amazonaws.com/interop-debezium-postgresql:latest"
debezium_postgresql_replicas                = 1
debezium_postgresql_cpu                     = "2"
debezium_postgresql_memory                  = "4Gi"
debezium_postgresql_role_name               = "interop-debezium-postgresql-dev"
debezium_postgresql_msk_cluster_arn         = "arn:aws:kafka:eu-central-1:505630707203:cluster/interop-events-dev/6fcdbd46-1fa8-4772-8737-231355352f73-s3"
debezium_postgresql_aurora_cluster_id       = "interop-persistence-management-dev"
debezium_postgresql_database_name           = "persistence_management"
debezium_postgresql_credentials_secret_name = "persistence-management-debezium-credentials"
debezium_routing_partitions                 = 3