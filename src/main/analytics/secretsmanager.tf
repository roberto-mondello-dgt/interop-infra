locals {
  redshift_users = {
    readonly                         = format("%s-analytics-readonly", local.project)
    be_analytics_domain_consumer     = module.be_analytics_domain_consumer_irsa.iam_role_name
    be_analytics_jwt_consumer        = module.be_analytics_jwt_consumer_irsa.iam_role_name
    tracing_be_enriched_data_handler = "tracing-be-enriched-data-handler-dev-es1"
    lorenzo_giorgi                   = "lorenzo_giorgi"
    eduardo_mihalache                = "eduardo_mihalache"
    diego_longo                      = "diego_longo"
    roberto_taglioni                 = "roberto_taglioni"
  }
}

resource "aws_secretsmanager_secret" "redshift_users" {
  for_each = (local.redshift_users)

  name = format("redshift/%s-analytics-%s/users/%s", local.project, var.env, each.value)

  # Necessary for Redshift log in integration
  tags = merge(var.tags, {
    Redshift = ""
  })
}

data "aws_secretsmanager_random_password" "redshift_users" {
  for_each = (local.redshift_users)

  password_length            = 30
  exclude_characters         = "\"@/'\\ "
  require_each_included_type = true
}

resource "aws_secretsmanager_secret_version" "redshift_users" {
  for_each = (local.redshift_users)

  secret_id = aws_secretsmanager_secret.redshift_users[each.key].id
  secret_string = jsonencode({
    username = each.value
    password = data.aws_secretsmanager_random_password.redshift_users[each.key].random_password
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}
