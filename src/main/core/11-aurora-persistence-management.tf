# TODO: rename after migration
data "aws_subnets" "aurora_persistence_management_v2" {
  filter {
    name   = "vpc-id"
    values = [module.vpc_v2.vpc_id]
  }

  filter {
    name   = "cidr-block"
    values = toset(local.aurora_persist_manag_cidrs)
  }
}

resource "aws_kms_key" "persistence_management" {
  description              = format("%s-aurora-persistence-management-%s", var.short_name, var.env)
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
}

# TODO: rename after migration
resource "aws_secretsmanager_secret" "persistence_management_master_v2" {
  name        = format("%s-persistence-management-master-%s", var.short_name, var.env)
  description = "Persistence Management DB master user credentials"
}

# TODO: rename after migration
data "aws_secretsmanager_random_password" "persistence_management_v2" {
  password_length            = 30
  exclude_characters         = "\"@/\\"
  require_each_included_type = true
}

# TODO: rename after migration
resource "aws_secretsmanager_secret_version" "persistence_management_credentials_v2" {
  secret_id = aws_secretsmanager_secret.persistence_management_master_v2.id
  secret_string = jsonencode({
    username = var.persistence_management_master_username
    password = data.aws_secretsmanager_random_password.persistence_management_v2.random_password
  })

  # TODO: handle rotation
  lifecycle {
    ignore_changes = [secret_string]
  }
}

# TODO: rename after migration
module "persistence_management_aurora_cluster_v2" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~> 8.0.2"

  # TODO: remove after migration
  snapshot_identifier = "arn:aws:rds:eu-central-1:697818730278:cluster-snapshot:vpc-migration-aurora-pg-20230525"

  name                = format("%s-persistence-management-%s", var.short_name, var.env)
  database_name       = var.persistence_management_database_name
  deletion_protection = true
  apply_immediately   = true

  auto_minor_version_upgrade = false

  manage_master_user_password = false
  master_username             = jsondecode(aws_secretsmanager_secret_version.persistence_management_credentials_v2.secret_string).username
  master_password             = jsondecode(aws_secretsmanager_secret_version.persistence_management_credentials_v2.secret_string).password

  engine             = "aurora-postgresql"
  engine_version     = var.persistence_management_engine_version
  instance_class     = var.persistence_management_instance_class
  ca_cert_identifier = var.persistence_management_ca_cert_id

  instances_use_identifier_prefix = false
  instances = { for n in range(var.persistence_management_number_instances) : "instance-${n + 1}" =>
    {
      identifier        = format("persistence-management-%d", n + 1)
      availability_zone = element(module.vpc_v2.azs, n)
  } }

  create_db_cluster_parameter_group          = true
  db_cluster_parameter_group_use_name_prefix = false
  db_cluster_parameter_group_name            = format("%s-persistence-management-cluster-param-group-%s", var.short_name, var.env)
  db_cluster_parameter_group_family          = var.persistence_management_parameter_group_family
  db_cluster_parameter_group_parameters = [
    {
      name  = "rds.force_ssl"
      value = 1
    }
  ]

  vpc_id             = module.vpc_v2.vpc_id
  subnets            = data.aws_subnets.aurora_persistence_management_v2.ids
  availability_zones = module.vpc_v2.azs

  create_db_subnet_group = true
  db_subnet_group_name   = format("%s-persist-manag-subnet-group-%s", var.short_name, var.env)

  create_security_group          = true
  security_group_use_name_prefix = false
  security_group_rules = {
    from_eks_cluster = {
      type                     = "ingress"
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      source_security_group_id = module.eks_v2.cluster_primary_security_group_id
    }

    from_bastion_host = {
      type                     = "ingress"
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      source_security_group_id = aws_security_group.bastion_host_v2.id
    }

    from_github_runners = {
      type                     = "ingress"
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      source_security_group_id = aws_security_group.github_runners_v2.id
    }

    from_vpn_clients = {
      type                     = "ingress"
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      source_security_group_id = aws_security_group.vpn_clients.id
    }
  }

  storage_encrypted       = true
  kms_key_id              = aws_kms_key.persistence_management.arn
  backup_retention_period = var.env == "prod" ? 30 : 7
  skip_final_snapshot     = false

  create_cloudwatch_log_group            = true
  enabled_cloudwatch_logs_exports        = ["postgresql"]
  cloudwatch_log_group_retention_in_days = var.env == "prod" ? 180 : 30

  create_monitoring_role                = true
  iam_role_name                         = format("%s-persist-manag-enhanced-monitoring-%s", var.short_name, var.env)
  performance_insights_enabled          = true
  performance_insights_retention_period = var.env == "prod" ? 372 : 7
  monitoring_interval                   = 60
  performance_insights_kms_key_id       = aws_kms_key.persistence_management.arn
}
