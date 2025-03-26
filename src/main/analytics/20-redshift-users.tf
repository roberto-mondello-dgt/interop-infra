locals {
  eks_secret_default_tags = {
    EKSClusterName                     = data.aws_eks_cluster.core.name
    EKSClusterNamespacesSpaceSeparated = join(" ", [var.analytics_k8s_namespace])
    TerraformState                     = local.terraform_state
  }
  redshift_host = element(split(":", aws_redshift_cluster.analytics[0].endpoint), 0)
}

module "redshift_flyway_pgsql_user" {
  count = local.deploy_data_ingestion_resources ? 1 : 0

  source = "git::https://github.com/pagopa/interop-infra-commons//terraform/modules/postgresql-user?ref=v1.9.0"

  username = "interop_analytics_flyway_user"

  generated_password_length = 30
  secret_prefix             = format("redshift/%s/users/", aws_redshift_cluster.analytics[0].cluster_identifier)

  secret_tags = merge(local.eks_secret_default_tags,
    {
      EKSReplicaSecretName = "redshift-flyway-user"
    }
  )

  redshift_cluster = true

  db_host = local.redshift_host
  db_port = aws_redshift_cluster.analytics[0].port
  db_name = aws_redshift_cluster.analytics[0].database_name

  db_admin_credentials_secret_arn = aws_secretsmanager_secret.redshift_master[0].arn

  additional_sql_statements = <<-EOT
    GRANT CREATE ON DATABASE ${aws_redshift_cluster.analytics[0].database_name} TO "interop_analytics_flyway_user";
    ALTER USER interop_analytics_flyway_user SET search_path TO '\$user';
  EOT
}

locals {
  be_app_psql_usernames = local.deploy_data_ingestion_resources ? {
    jwt_audit_analytics_writer_user = {
      sql_name        = "interop_be_jwt_audit_analytics_writer_${var.env}",
      k8s_secret_name = "redshift-jwt-audit-analytics-writer-user"
    },
    domains_analytics_writer_user = {
      sql_name        = "interop_be_domains_analytics_writer_${var.env}",
      k8s_secret_name = "redshift-domains-analytics-writer-user"
    },
    alb_logs_analytics_writer_user = {
      sql_name        = "interop_be_alb_logs_analytics_writer_${var.env}",
      k8s_secret_name = "redshift-alb-logs-analytics-writer-user"
    },
    application_audit_analytics_writer_user = {
      sql_name        = "interop_be_application_audit_analytics_writer_${var.env}",
      k8s_secret_name = "redshift-application-audit-analytics-writer-user"
    }
  } : {}

  devs_psql_usernames = local.deploy_data_ingestion_resources ? {
    readonly = {
      sql_name = "interop_analytics_readonly"
    },
    lorenzo_giorgi = {
      sql_name = "lorenzo_giorgi"
    },
    eduardo_mihalache = {
      sql_name = "eduardo_mihalache"
    },
    diego_longo = {
      sql_name = "diego_longo"
    },
    roberto_taglioni = {
      sql_name = "roberto_taglioni"
    }
  } : {}
}

# PostgreSQL users with no initial grants. The grants will be applied by Flyway
module "redshift_be_app_pgsql_user" {
  source = "git::https://github.com/pagopa/interop-infra-commons//terraform/modules/postgresql-user?ref=v1.9.0"

  for_each = local.be_app_psql_usernames

  username = each.value.sql_name

  generated_password_length = 30
  secret_prefix             = format("redshift/%s/users/", aws_redshift_cluster.analytics[0].cluster_identifier)

  secret_tags = merge(local.eks_secret_default_tags,
    {
      EKSReplicaSecretName = each.value.k8s_secret_name
    }
  )

  redshift_cluster = true

  db_host = local.redshift_host
  db_port = aws_redshift_cluster.analytics[0].port
  db_name = aws_redshift_cluster.analytics[0].database_name

  db_admin_credentials_secret_arn = aws_secretsmanager_secret.redshift_master[0].arn
}

# PostgreSQL users for developers with default privileges.
module "redshift_devs_pgsql_user" {
  source = "git::https://github.com/pagopa/interop-infra-commons//terraform/modules/postgresql-user?ref=v1.10.0"

  for_each = local.devs_psql_usernames

  username = each.value.sql_name

  generated_password_length = 30
  secret_prefix             = format("redshift/%s/users/", aws_redshift_cluster.analytics[0].cluster_identifier)

  secret_tags = merge(var.tags, {
    Redshift = "" # Necessary for Redshift log-in integration when using Quey editor v2
  })

  redshift_cluster = true

  db_host = local.redshift_host
  db_port = aws_redshift_cluster.analytics[0].port
  db_name = aws_redshift_cluster.analytics[0].database_name

  db_admin_credentials_secret_arn = aws_secretsmanager_secret.redshift_master[0].arn

  grant_redshift_groups = ["readonly_group"]

  additional_sql_statements = <<-EOT
    ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES TO "${each.value.sql_name}";
  EOT
}