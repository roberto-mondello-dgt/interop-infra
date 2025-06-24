aws_region = "eu-south-1"
env        = "dev"
azs        = ["eu-south-1a", "eu-south-1b", "eu-south-1c"]

tags = {
  CreatedBy   = "Terraform"
  Environment = "dev"
  Owner       = "PagoPA"
  Source      = "https://github.com/pagopa/interop-infra"
}

sso_admin_role_name = "AWSReservedSSO_FullAdmin_51f0f6735b64a7f9"

vpc_id               = "vpc-0df5f0ee96b0824c7"
analytics_subnet_ids = ["subnet-0f7445d4c56f10f3b", "subnet-0946493be6a7d2fbd", "subnet-05537a9801f26457c"]

vpn_clients_security_group_id = "sg-0f9493c196a3efc3d"

eks_cluster_name                   = "interop-eks-cluster-dev"
eks_cluster_node_security_group_id = "sg-044f18e11c91e71ed"

redshift_cluster_nodes_number = 2
redshift_cluster_nodes_type   = "ra3.xlplus"

jwt_details_bucket_name = "interop-generated-jwt-details-dev-es1"
alb_logs_bucket_name    = "interop-alb-logs-dev-es1"

tracing_aws_account_id = "590183909663"
tracing_vpc_id         = "vpc-0a08140b4517ce27d"

analytics_qa_account_id = "755649575658"
analytics_qa_vpc_id     = "vpc-0b2becb736d65a01d"

analytics_k8s_namespace = "dev-analytics"

deployment_repo_name = "pagopa/interop-analytics-deployment"

s3_reprocess_repo_name = "pagopa/interop-s3-reprocess"

github_runner_task_role_name = "interop-github-runner-task-dev-es1"

msk_cluster_name = "interop-platform-events-dev"

msk_monitoring_app_audit_max_offset_lag_threshold = 500
msk_monitoring_app_audit_evaluation_periods       = 5
msk_monitoring_app_audit_period_seconds           = 60

application_audit_producers_irsa_list = [
  "interop-be-agreement-process-dev-es1",
  "interop-be-api-gateway-dev-es1",
  "interop-be-authorization-server-dev-es1",
  "interop-be-backend-for-frontend-dev-es1",
  "interop-be-catalog-process-dev-es1",
  "interop-be-delegation-process-dev-es1",
  "interop-be-m2m-gateway-dev-es1",
  "interop-be-purpose-process-dev-es1",
  "interop-be-tenant-process-dev-es1"
]

quicksight_identity_center_arn    = "arn:aws:sso:::instance/ssoins-6804d580c9a0bfbc"
quicksight_identity_center_region = "eu-west-1"

quicksight_notification_email = "pdnd-interop+dev@pagopa.it"
