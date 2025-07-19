aws_region = "eu-south-1"
env        = "prod"
azs        = ["eu-south-1a", "eu-south-1b", "eu-south-1c"]

tags = {
  CreatedBy   = "Terraform"
  Environment = "prod"
  Owner       = "PagoPA"
  Source      = "https://github.com/pagopa/interop-infra"
}

sso_admin_role_name = "AWSReservedSSO_FullAdmin_afdc92d80f0cc31a"

vpc_id               = "vpc-0c08ca99a78bc66fc"
analytics_subnet_ids = ["subnet-0872428e8ba3b6367", "subnet-0015a3c56e67e8e3b", "subnet-0a39cd632de1fc94e"]

vpn_clients_security_group_id = "sg-055befcb353d34605"

eks_cluster_name                   = "interop-eks-cluster-prod"
eks_cluster_node_security_group_id = "sg-07bf14d46249b8681"

redshift_cluster_nodes_number = 2
redshift_cluster_nodes_type   = "ra3.xlplus"

jwt_details_bucket_name = "interop-generated-jwt-details-prod-es1"
alb_logs_bucket_name    = "interop-alb-logs-prod-es1"

analytics_k8s_namespace = "prod-analytics"

deployment_repo_name = "pagopa/interop-analytics-deployment"

s3_reprocess_repo_name = "pagopa/interop-s3-reprocess"

github_runner_task_role_name = "interop-github-runner-task-prod-es1"

msk_cluster_name = "interop-platform-events-prod"

msk_monitoring_app_audit_max_offset_lag_threshold = 1000
msk_monitoring_app_audit_evaluation_periods       = 5
msk_monitoring_app_audit_period_seconds           = 60

application_audit_producers_irsa_list = [
  "interop-be-agreement-process-prod-es1",
  "interop-be-api-gateway-prod-es1",
  "interop-be-authorization-server-prod-es1",
  "interop-be-backend-for-frontend-prod-es1",
  "interop-be-catalog-process-prod-es1",
  "interop-be-delegation-process-prod-es1",
  "interop-be-m2m-gateway-prod-es1",
  "interop-be-purpose-process-prod-es1",
  "interop-be-tenant-process-prod-es1"
]

quicksight_identity_center_arn    = "arn:aws:sso:::instance/ssoins-6804d580c9a0bfbc"
quicksight_identity_center_region = "eu-west-1"

quicksight_notification_email = "pdnd-interop+prod@pagopa.it"
