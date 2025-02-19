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

sns_topic_name = "interop-platform-alarms-prod"

analytics_k8s_namespace = "prod-analytics"

deployment_repo_name = "pagopa/interop-analytics-deployment"

github_runner_task_role_name = "interop-github-runner-task-prod-es1"

msk_cluster_name = "interop-platform-events-prod"
