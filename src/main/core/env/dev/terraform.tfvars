aws_region = "eu-central-1"
env        = "dev"
short_name = "interop"

tags = {
  CreatedBy   = "Terraform"
  Environment = "dev"
  Owner       = "PagoPA"
  Source      = "https://github.com/pagopa/interop-infra"
}

bastion_host_ami_id              = "ami-094c442a8e9a67935"
bastion_host_instance_type       = "t2.micro"
bastion_host_private_ip          = "172.32.0.7"
bastion_host_security_group_name = "interop-bastion-host-dev-BastionSecurityGroup-WP1X6VLMIUMW"
bastion_host_ssh_cidr            = "0.0.0.0/0"
bastion_host_key_pair            = "interop-bh-key-dev"

eks_cluster_name = "interop-eks-dev"

persistence_management_cluster_id             = "interop-rds-dev-auroradbcluster-1ws49gkll6459"
persistence_management_database_name          = "persistence_management"
persistence_management_engine_version         = "13.9"
persistence_management_instance_class         = "db.t4g.medium"
persistence_management_subnet_group_name      = "interop-rds-dev-dbsubnetgroup-fk3mnuj6th50"
persistence_management_parameter_group_name   = "interop-rds-dev-rdsdbclusterparametergroup-pmkjrep8gv9p"
persistence_management_parameter_group_family = "aurora-postgresql13"
persistence_management_master_username        = "root"
persistence_management_primary_instance_id    = "iaf29k8l5z7a59"
persistence_management_replica1_instance_id   = "ia191bvain9ri2q"
persistence_management_replica2_instance_id   = "iacgbfxq3g2q6b"

read_model_cluster_id           = "read-model"
read_model_master_username      = "root"
read_model_engine_version       = "4.0.0"
read_model_instance_class       = "db.t4g.medium"
read_model_subnet_group_name    = "docdbsubnetgroup-juvy8znmt1bi"
read_model_parameter_group_name = "read-model-parameter-group"

notification_events_table_ttl_enabled = true

backend_integration_alb_name = "k8s-dev-interops-9d1ad7f6b4"

github_runners_allowed_repos = ["pagopa/pdnd-interop-platform-deployment", "pagopa/interop-github-runner-aws"]
github_runners_cpu           = 2048
github_runners_memory        = 4096
github_runners_image_uri     = "ghcr.io/pagopa/interop-github-runner-aws:v1.10.0"

dns_interop_base_domain = "interop.pagopa.it"

data_lake_account_id  = "688071769384"
data_lake_external_id = "ac94a267-b8fc-4ecc-8294-8302795e8ba3"

probing_registry_reader_role_arn = "arn:aws:iam::774300547186:role/application/eks/pods/interop-be-probing-registry-reader-dev"

interop_auth_openapi_path = "./openapi/dev/auth-server/interop-auth-server-adc891fab798b0da9fd9990d686e97c3ee6493ff.yaml"
interop_api_openapi_path  = "./openapi/dev/internal-api-gateway/interop-api-v1.0-04797574cb3dfc89d34f7f2b328a1048c5b21ee5.yaml"
