aws_region = "eu-south-1"
env        = "qa"
azs        = ["eu-south-1a", "eu-south-1b", "eu-south-1c"]

tags = {
  CreatedBy   = "Terraform"
  Environment = "qa"
  Owner       = "PagoPA"
  Source      = "https://github.com/pagopa/interop-infra"
}

sso_admin_role_name = "AWSReservedSSO_FullAdmin_5dbb9b56c9f20407"

vpc_id               = "vpc-0b2becb736d65a01d"
analytics_subnet_ids = []

vpn_clients_security_group_id = "sg-052f19b77ef0a37f3"

eks_cluster_name                   = "interop-eks-cluster-qa"
eks_cluster_node_security_group_id = "sg-03a32a7ba847306f4"

redshift_cluster_nodes_number = 2
redshift_cluster_nodes_type   = "ra3.xlplus"

jwt_details_bucket_name = "interop-generated-jwt-details-qa-es1"
alb_logs_bucket_name    = "interop-alb-logs-qa-es1"

analytics_k8s_namespace = "qa-analytics"

deployment_repo_name = "pagopa/interop-analytics-deployment"

s3_reprocess_repo_name = "pagopa/interop-s3-reprocess"

github_runner_task_role_name = "interop-github-runner-task-qa-es1"

msk_cluster_name = "interop-platform-events-qa"

msk_monitoring_app_audit_max_offset_lag_threshold = 500
msk_monitoring_app_audit_evaluation_periods       = 5
msk_monitoring_app_audit_period_seconds           = 60

application_audit_producers_irsa_list = [
  "interop-be-agreement-process-qa-es1",
  "interop-be-api-gateway-qa-es1",
  "interop-be-authorization-server-qa-es1",
  "interop-be-backend-for-frontend-qa-es1",
  "interop-be-catalog-process-qa-es1",
  "interop-be-delegation-process-qa-es1",
  "interop-be-m2m-gateway-qa-es1",
  "interop-be-purpose-process-qa-es1",
  "interop-be-tenant-process-qa-es1"
]
