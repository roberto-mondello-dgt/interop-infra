locals {
  eks_secret_default_tags = {
    EKSClusterName                     = module.eks.cluster_name
    EKSClusterNamespacesSpaceSeparated = join(" ", [var.env])
    TerraformState                     = local.terraform_state
  }
}

module "platform_data_flyway_pgsql_user" {
  count = local.deploy_read_model_refactor ? 1 : 0

  source = "git::https://github.com/pagopa/interop-infra-commons//terraform/modules/postgresql-user?ref=v1.7.1"

  username = "flyway_user"

  generated_password_length = 30
  secret_prefix             = format("rds/%s/users/", module.platform_data.cluster_id)

  secret_tags = merge(local.eks_secret_default_tags,
    {
      EKSReplicaSecretName = "platform-data-flyway-user"
    }
  )

  db_host = module.platform_data.cluster_endpoint
  db_port = module.platform_data.cluster_port
  db_name = "read_model" # PG roles are "global", we just a need an existing database

  db_admin_credentials_secret_arn = module.platform_data.cluster_master_user_secret[0].secret_arn

  additional_sql_statements = <<-EOT
    GRANT CREATE ON DATABASE "persistence_management" TO "flyway_user";
    GRANT CREATE ON DATABASE "read_model" TO "flyway_user";
  EOT
}

module "platform_data_readonly_pgsql_user" {
  count = local.deploy_read_model_refactor ? 1 : 0

  source = "git::https://github.com/pagopa/interop-infra-commons//terraform/modules/postgresql-user?ref=v1.7.1"

  username = "readonly_user"

  generated_password_length = 30
  secret_prefix             = format("rds/%s/users/", module.platform_data.cluster_id)

  secret_tags = merge(local.eks_secret_default_tags,
    {
      EKSReplicaSecretName = "platform-data-readonly-user"
    }
  )

  db_host = module.platform_data.cluster_endpoint
  db_port = module.platform_data.cluster_port
  db_name = "read_model" # PG roles are "global", we just a need an existing database

  db_admin_credentials_secret_arn = module.platform_data.cluster_master_user_secret[0].secret_arn

  additional_sql_statements = <<-EOT
    ALTER DEFAULT PRIVILEGES GRANT USAGE ON SCHEMAS TO readonly_user;
    ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES TO readonly_user;
    ALTER DEFAULT PRIVILEGES GRANT SELECT ON SEQUENCES TO readonly_user;
  EOT
}

locals {
  be_app_psql_usernames = local.deploy_read_model_refactor ? {
    attribute_registry_rmw_user = {
      sql_name        = "${var.env}_attribute_registry_rmw_user",
      k8s_secret_name = "platform-data-attribute-registry-rmw-user"
    },
    attribute_registry_process_user = {
      sql_name        = "${var.env}_attribute_registry_process_user",
      k8s_secret_name = "platform-data-attribute-registry-process-user"
    },
    agreement_rmw_user = {
      sql_name        = "${var.env}_agreement_rmw_user",
      k8s_secret_name = "platform-data-agreement-rmw-user"
    },
    agreement_process_user = {
      sql_name        = "${var.env}_agreement_process_user",
      k8s_secret_name = "platform-data-agreement-process-user"
    },
    api_gateway_user = {
      sql_name        = "${var.env}_api_gateway_user",
      k8s_secret_name = "platform-data-api-gateway-user"
    },
    key_rmw_user = {
      sql_name        = "${var.env}_key_rmw_user",
      k8s_secret_name = "platform-data-key-rmw-user"
    },
    producer_key_rmw_user = {
      sql_name        = "${var.env}_producer_key_rmw_user",
      k8s_secret_name = "platform-data-producer-key-rmw-user"
    },
    purpose_rmw_user = {
      sql_name        = "${var.env}_purpose_rmw_user",
      k8s_secret_name = "platform-data-purpose-rmw-user"
    },
    purpose_process_user = {
      sql_name        = "${var.env}_purpose_process_user",
      k8s_secret_name = "platform-data-purpose-process-user"
    },
    client_rmw_user = {
      sql_name        = "${var.env}_client_rmw_user",
      k8s_secret_name = "platform-data-client-rmw-user"
    },
    authorization_process_user = {
      sql_name        = "${var.env}_authorization_process_user",
      k8s_secret_name = "platform-data-authorization-process-user"
    },
    producer_keychain_rmw_user = {
      sql_name        = "${var.env}_producer_keychain_rmw_user",
      k8s_secret_name = "platform-data-producer-keychain-rmw-user"
    },
    tenant_rmw_user = {
      sql_name        = "${var.env}_tenant_rmw_user",
      k8s_secret_name = "platform-data-tenant-rmw-user"
    },
    tenant_process_user = {
      sql_name        = "${var.env}_tenant_process_user",
      k8s_secret_name = "platform-data-tenant-process-user"
    },
    tenant_rmw_user = {
      sql_name        = "${var.env}_tenant_rmw_user",
      k8s_secret_name = "platform-data-tenant-rmw-user"
    },
    tenant_process_user = {
      sql_name        = "${var.env}_tenant_process_user",
      k8s_secret_name = "platform-data-tenant-process-user"
    },
    delegation_rmw_user = {
      sql_name        = "${var.env}_delegation_rmw_user",
      k8s_secret_name = "platform-data-delegation-rmw-user"
    },
    delegation_process_user = {
      sql_name        = "${var.env}_delegation_process_user",
      k8s_secret_name = "platform-data-delegation-process-user"
    },
    catalog_rmw_user = {
      sql_name        = "${var.env}_catalog_rmw_user",
      k8s_secret_name = "platform-data-catalog-rmw-user"
    },
    catalog_process_user = {
      sql_name        = "${var.env}_catalog_process_user",
      k8s_secret_name = "platform-data-catalog-process-user"
    },
  } : {}
}

# PostgreSQL users with no initial grants. The grants will be applied by Flyway
module "platform_data_be_app_pgsql_user" {
  source = "git::https://github.com/pagopa/interop-infra-commons//terraform/modules/postgresql-user?ref=v1.7.1"

  for_each = local.be_app_psql_usernames

  username = each.value.sql_name

  generated_password_length = 30
  secret_prefix             = format("rds/%s/users/", module.platform_data.cluster_id)

  secret_tags = merge(local.eks_secret_default_tags,
    {
      EKSReplicaSecretName = each.value.k8s_secret_name
    }
  )

  db_host = module.platform_data.cluster_endpoint
  db_port = module.platform_data.cluster_port
  db_name = "read_model" # PG roles are "global", we just a need an existing database

  db_admin_credentials_secret_arn = module.platform_data.cluster_master_user_secret[0].secret_arn
}
