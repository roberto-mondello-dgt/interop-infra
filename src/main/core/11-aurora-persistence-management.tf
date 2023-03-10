data "aws_subnets" "persistence_management_aurora" {
  filter {
    name   = "tag:Name"
    values = local.aurora_subnets_names
  }
}

resource "aws_kms_key" "persistence_management" {
  description              = format("%s-aurora-persistence-management-%s", var.short_name, var.env)
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
}

## TODO: rename/migrate secret if possible (split for future DBs)
resource "aws_secretsmanager_secret" "persistence_management_master" {
  name        = format("%s/aurora-pg/interop-rds-%s", var.env, var.env)
  description = "Persistence Management DB master user credentials"
}

data "aws_secretsmanager_random_password" "persistence_management" {
  password_length            = 30
  exclude_characters         = "\"@/\\"
  require_each_included_type = true
}

resource "aws_secretsmanager_secret_version" "persistence_management_credentials" {
  secret_id = aws_secretsmanager_secret.persistence_management_master.id
  secret_string = jsonencode({
    username = var.persistence_management_master_username
    password = data.aws_secretsmanager_random_password.persistence_management.random_password
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}

# TODO: rename cluster, sg, instances identifiers
module "persistence_management_aurora_cluster" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~> 7.6.2"

  name                = var.persistence_management_cluster_id
  database_name       = var.persistence_management_database_name
  deletion_protection = true
  apply_immediately   = true

  create_random_password = false
  master_username        = jsondecode(aws_secretsmanager_secret_version.persistence_management_credentials.secret_string).username
  master_password        = jsondecode(aws_secretsmanager_secret_version.persistence_management_credentials.secret_string).password

  engine         = "aurora-postgresql"
  engine_version = var.persistence_management_engine_version
  instance_class = var.persistence_management_instance_class

  instances = {
    primary = {
      identifier = var.persistence_management_primary_instance_id
    }
    replica1 = {
      identifier = var.persistence_management_replica1_instance_id
    }
    replica2 = {
      identifier = var.persistence_management_replica2_instance_id
    }
  }

  # TODO: let the module manage the parameter group name/family/description, will it cause downtime?
  create_db_cluster_parameter_group          = true
  db_cluster_parameter_group_use_name_prefix = false
  db_cluster_parameter_group_name            = var.persistence_management_parameter_group_name
  db_cluster_parameter_group_family          = var.persistence_management_parameter_group_family
  db_cluster_parameter_group_description     = "Aurora PG Cluster Parameter Group - persistence_management"
  db_cluster_parameter_group_parameters = [
    {
      name  = "rds.force_ssl"
      value = 1
    }
  ]

  vpc_id               = module.vpc.vpc_id
  subnets              = data.aws_subnets.persistence_management_aurora.ids
  db_subnet_group_name = var.persistence_management_subnet_group_name

  # TODO: use only SGs for allowing traffic
  security_group_description          = format("%s-rds-%s", var.short_name, var.env)
  security_group_use_name_prefix      = false
  allowed_security_groups             = data.aws_security_groups.backend.ids
  allowed_cidr_blocks                 = [module.vpc.vpc_cidr_block]
  iam_database_authentication_enabled = true

  storage_encrypted       = true
  kms_key_id              = aws_kms_key.persistence_management.arn
  backup_retention_period = var.env == "prod" ? 30 : 7
  skip_final_snapshot     = false

  enabled_cloudwatch_logs_exports       = ["postgresql"]
  monitoring_interval                   = 60
  iam_role_name                         = format("InteropAuroraPersistenceManagementEnhancedMonitoring-%s", title(var.env))
  performance_insights_enabled          = true
  performance_insights_retention_period = var.env == "prod" ? 731 : 7
  performance_insights_kms_key_id       = aws_kms_key.persistence_management.arn
}
