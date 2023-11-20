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

kube_state_metrics_image_version_tag = "v2.6.0"
kube_state_metrics_cpu               = "250m"
kube_state_metrics_memory            = "128Mi"

adot_collector_role_name = "adot-collector-qa"
adot_collector_image_uri = "amazon/aws-otel-collector:v0.30.0"

aws_load_balancer_controller_role_name = "aws-load-balancer-controller-qa"

enable_fluentbit_process_logs            = false
container_logs_cloudwatch_retention_days = 30
