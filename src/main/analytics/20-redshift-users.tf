locals {
  eks_secret_default_tags = {
    EKSClusterName                     = data.aws_eks_cluster.core.name
    EKSClusterNamespacesSpaceSeparated = join(" ", [var.analytics_k8s_namespace])
    TerraformState                     = local.terraform_state
  }

  # The following locals are useful to define the Redshift cluster connection parameters in case of a cross-account Redshift cluster
  redshift_host         = local.deploy_redshift_cluster ? element(split(":", aws_redshift_cluster.analytics[0].endpoint), 0) : data.aws_redshift_cluster.cross_account[0].endpoint
  redshift_cluster_name = local.deploy_redshift_cluster ? aws_redshift_cluster.analytics[0].cluster_identifier : data.aws_redshift_cluster.cross_account[0].cluster_identifier
  redshift_port         = local.deploy_redshift_cluster ? aws_redshift_cluster.analytics[0].port : data.aws_redshift_cluster.cross_account[0].port
  redshift_database     = local.deploy_redshift_cluster ? aws_redshift_cluster.analytics[0].database_name : var.redshift_cross_account_cluster.database_name

  redshift_master_user_secret_arn = local.deploy_redshift_cluster ? aws_secretsmanager_secret.redshift_master[0].arn : data.aws_secretsmanager_secret.redshift_master_cross_account[0].arn
}

module "redshift_flyway_pgsql_user" {
  source = "git::https://github.com/pagopa/interop-infra-commons//terraform/modules/postgresql-user?ref=v1.27.6"

  username = format("%s_flyway_user", var.env)

  generated_password_length = 30
  secret_prefix             = format("redshift/%s/users/", local.redshift_cluster_name)

  secret_tags = merge(local.eks_secret_default_tags,
    {
      EKSReplicaSecretName = "redshift-flyway-user"
    }
  )

  redshift_cluster = true

  db_host = local.redshift_host
  db_port = local.redshift_port
  db_name = local.redshift_database

  db_admin_credentials_secret_arn = local.redshift_master_user_secret_arn

  additional_sql_statements = <<-EOT
    GRANT CREATE ON DATABASE ${local.redshift_database} TO "${format("%s_flyway_user", var.env)}";
    ALTER USER "${format("%s_flyway_user", var.env)}" SET search_path TO '\$user';
  EOT
}

locals {
  redshift_users_json_data = jsondecode(file("./assets/redshift-users/redshift-users-${var.env}.json"))

  be_app_psql_usernames = try([
    for user in local.redshift_users_json_data.be_app_users : user
  ], [])

  readonly_psql_usernames = try([
    for user in local.redshift_users_json_data.readonly_users : user
  ], [])
}

# PostgreSQL users with no initial grants. The grants will be applied by Flyway
module "redshift_be_app_pgsql_user" {
  source = "git::https://github.com/pagopa/interop-infra-commons//terraform/modules/postgresql-user?ref=v1.27.6"

  for_each = toset(local.be_app_psql_usernames)

  username = format("%s_%s", var.env, each.value)

  generated_password_length = 30
  secret_prefix             = format("redshift/%s/users/", local.redshift_cluster_name)

  secret_tags = merge(local.eks_secret_default_tags,
    {
      EKSReplicaSecretName = format("redshift-%s", replace(each.value, "_", "-"))
    }
  )

  redshift_cluster = true

  db_host = local.redshift_host
  db_port = local.redshift_port
  db_name = local.redshift_database

  db_admin_credentials_secret_arn = local.redshift_master_user_secret_arn
}

# PostgreSQL users for developers with default privileges.
module "redshift_readonly_pgsql_user" {
  source = "git::https://github.com/pagopa/interop-infra-commons//terraform/modules/postgresql-user?ref=v1.27.6"

  for_each = toset(local.readonly_psql_usernames)

  username = each.value

  generated_password_length = 30
  secret_prefix             = format("redshift/%s/users/", local.redshift_cluster_name)

  secret_tags = merge(var.tags, {
    Redshift = "" # Necessary for Redshift log-in integration when using Quey editor v2
  })

  redshift_cluster = true

  db_host = local.redshift_host
  db_port = local.redshift_port
  db_name = local.redshift_database

  db_admin_credentials_secret_arn = local.redshift_master_user_secret_arn

  grant_redshift_groups = ["readonly_group"]

  additional_sql_statements = <<-EOT
    ALTER DEFAULT PRIVILEGES FOR USER ${format("%s_flyway_user", var.env)} GRANT SELECT ON TABLES TO GROUP readonly_group;
  EOT
}

module "redshift_quicksight_pgsql_user" {
  count = local.deploy_redshift_cluster ? 1 : 0

  source = "git::https://github.com/pagopa/interop-infra-commons//terraform/modules/postgresql-user?ref=v1.27.6"

  username = "${var.env}_quicksight_user"

  generated_password_length = 30
  secret_prefix             = format("redshift/%s/users/", local.redshift_cluster_name)

  secret_tags = merge(var.tags, {
    Redshift = "" # Necessary for Redshift log-in integration when using Quey editor v2
  })

  redshift_cluster = true

  db_host = local.redshift_host
  db_port = local.redshift_port
  db_name = local.redshift_database

  db_admin_credentials_secret_arn = local.redshift_master_user_secret_arn
}
