locals {
  readonly_username                         = format("%s-analytics-readonly", local.project)
  be_analytics_domain_consumer_username     = module.be_analytics_domain_consumer_irsa.iam_role_name
  be_analytics_jwt_consumer_username        = module.be_analytics_jwt_consumer_irsa.iam_role_name
  tracing_be_enriched_data_handler_username = "tracing-be-enriched-data-handler-dev-es1"
}

resource "aws_secretsmanager_secret" "readonly" {
  name        = format("redshift/%s-analytics-%s/users/%s", local.project, var.env, local.readonly_username)
  description = "Credentials for the interop-analytics-readonly user"

  # Necessary for Redshift log in integration
  tags = merge(var.tags, {
    Redshift = ""
  })
}

resource "aws_secretsmanager_secret" "be_analytics_domain_consumer" {
  name        = format("redshift/%s-analytics-%s/users/%s", local.project, var.env, local.be_analytics_domain_consumer_username)
  description = "Credentials for the interop-be-analytics-domain-consumer-dev-es1 user"

  # Necessary for Redshift log in integration
  tags = merge(var.tags, {
    Redshift = ""
  })
}

resource "aws_secretsmanager_secret" "be_analytics_jwt_consumer" {
  name        = format("redshift/%s-analytics-%s/users/%s", local.project, var.env, local.be_analytics_jwt_consumer_username)
  description = "Credentials for the interop-be-analytics-jwt-consumer-dev-es1 user"

  # Necessary for Redshift log in integration
  tags = merge(var.tags, {
    Redshift = ""
  })
}

resource "aws_secretsmanager_secret" "tracing_be_enriched_data_handler" {
  name        = format("redshift/%s-analytics-%s/users/%s", local.project, var.env, local.tracing_be_enriched_data_handler_username)
  description = "Credentials for the tracing-be-enriched-data-handler-dev-es1 user"

  # Necessary for Redshift log in integration
  tags = merge(var.tags, {
    Redshift = ""
  })
}

data "aws_secretsmanager_random_password" "readonly" {
  password_length            = 30
  exclude_characters         = "\"@/\\"
  require_each_included_type = true
}

data "aws_secretsmanager_random_password" "be_analytics_domain_consumer" {
  password_length            = 30
  exclude_characters         = "\"@/\\"
  require_each_included_type = true
}

data "aws_secretsmanager_random_password" "be_analytics_jwt_consumer" {
  password_length            = 30
  exclude_characters         = "\"@/\\"
  require_each_included_type = true
}

data "aws_secretsmanager_random_password" "tracing_be_enriched_data_handler" {
  password_length            = 30
  exclude_characters         = "\"@/\\"
  require_each_included_type = true
}

resource "aws_secretsmanager_secret_version" "readonly" {
  secret_id = aws_secretsmanager_secret.readonly.id
  secret_string = jsonencode({
    username = local.readonly_username
    password = data.aws_secretsmanager_random_password.readonly.random_password
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}

resource "aws_secretsmanager_secret_version" "be_analytics_domain_consumer" {
  secret_id = aws_secretsmanager_secret.be_analytics_domain_consumer.id
  secret_string = jsonencode({
    username = local.be_analytics_domain_consumer_username
    password = data.aws_secretsmanager_random_password.be_analytics_domain_consumer.random_password
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}

resource "aws_secretsmanager_secret_version" "be_analytics_jwt_consumer" {
  secret_id = aws_secretsmanager_secret.be_analytics_jwt_consumer.id
  secret_string = jsonencode({
    username = local.be_analytics_jwt_consumer_username
    password = data.aws_secretsmanager_random_password.be_analytics_jwt_consumer.random_password
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}

resource "aws_secretsmanager_secret_version" "tracing_be_enriched_data_handler" {
  secret_id = aws_secretsmanager_secret.tracing_be_enriched_data_handler.id
  secret_string = jsonencode({
    username = local.tracing_be_enriched_data_handler_username
    password = data.aws_secretsmanager_random_password.tracing_be_enriched_data_handler.random_password
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}