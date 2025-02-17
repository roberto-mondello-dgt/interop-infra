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
eks_cluster_node_security_group_id = "sg-0724f622cc3083979"

redshift_cluster_nodes_number = 2
redshift_cluster_nodes_type   = "ra3.xlplus"

jwt_details_bucket_name = "interop-generated-jwt-details-dev-es1"

tracing_aws_account_id = "590183909663"
tracing_vpc_id         = "vpc-0a08140b4517ce27d"

sns_topic_name = "interop-platform-alarms-dev"

analytics_k8s_namespace = "dev-analytics"

deployment_repo_name = "pagopa/interop-analytics-deployment"

github_runner_task_role_name = "interop-github-runner-task-dev-es1"
