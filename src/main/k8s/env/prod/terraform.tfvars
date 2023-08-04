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
