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
adot_collector_image_uri = "amazon/aws-otel-collector:v0.20.0"

aws_load_balancer_controller_role_name = "aws-load-balancer-controller-test"

enable_fluentbit_process_logs            = false
container_logs_cloudwatch_retention_days = 30
