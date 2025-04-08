aws_region = "eu-south-1"
env        = "vapt"
app_name   = "interop"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Vapt"
  Owner       = "PagoPA"
  Source      = "https://github.com/pagopa/interop-infra"
}

eks_cluster_name = "interop-eks-cluster-vapt"
be_prefix        = "interop-be"

sso_full_admin_role_name = "AWSReservedSSO_FullAdmin_92bf78ef453cd095"

fargate_profiles_roles_names = ["Interop-EKS-SystemProfile", "Interop-EKS-ApplicationProfile", "Interop-EKS-ObservabilityProfile"]

kube_state_metrics_image_version_tag = "v2.6.0"
kube_state_metrics_cpu               = "250m"
kube_state_metrics_memory            = "128Mi"

adot_collector_role_name = "adot-collector-vapt-es1"
adot_collector_image_uri = "amazon/aws-otel-collector:v0.39.1"

aws_load_balancer_controller_role_name = "aws-load-balancer-controller-vapt-es1"

enable_fluentbit_process_logs            = false
container_logs_cloudwatch_retention_days = 30

debezium_postgresql_image_uri               = "505630707203.dkr.ecr.eu-south-1.amazonaws.com/interop-debezium-postgresql:latest"
debezium_postgresql_replicas                = 1
debezium_postgresql_cpu                     = "2"
debezium_postgresql_memory                  = "4Gi"
debezium_postgresql_role_name               = "interop-debezium-postgresql-vapt-es1"
debezium_postgresql_msk_cluster_arn         = "arn:aws:kafka:eu-south-1:565393043798:cluster/interop-platform-events-vapt/f0607bfe-43f7-4a2b-b960-fed5348fe20e-3"
debezium_postgresql_aurora_cluster_id       = "interop-platform-data-vapt"
debezium_postgresql_database_name           = "persistence_management"
debezium_postgresql_credentials_secret_name = "platform-data-debezium-credentials"
debezium_routing_partitions                 = 3
