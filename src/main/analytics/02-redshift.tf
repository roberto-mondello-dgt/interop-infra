resource "aws_secretsmanager_secret" "redshift_master" {
  name = format("redshift/%s-analytics-%s/users/%s", local.project, var.env, var.redshift_master_username)

  # Necessary for Redshift log in integration
  tags = merge(var.tags, {
    Redshift = ""
  })
}

data "aws_secretsmanager_random_password" "redshift_master" {
  password_length            = 30
  exclude_characters         = "\"@/'\\ "
  require_each_included_type = true
}

resource "aws_secretsmanager_secret_version" "redshift_master" {
  secret_id = aws_secretsmanager_secret.redshift_master.id
  secret_string = jsonencode({
    username = var.redshift_master_username
    password = data.aws_secretsmanager_random_password.redshift_master.random_password
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}

resource "aws_kms_key" "analytics" {
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
}

resource "aws_kms_alias" "analytics" {
  name          = format("alias/redshift/%s-analytics-%s", local.project, var.env)
  target_key_id = aws_kms_key.analytics.key_id
}

resource "aws_redshift_parameter_group" "analytics" {
  name   = format("%s-analytics-%s", local.project, var.env)
  family = "redshift-1.0"
}

resource "aws_cloudwatch_log_group" "connectionlog" {
  name = format("/aws/redshift/cluster/%s-analytics-%s/connectionlog", local.project, var.env)

  retention_in_days = var.env == "prod" ? 90 : 30
  skip_destroy      = true
}

resource "aws_cloudwatch_log_group" "useractivitylog" {
  name = format("/aws/redshift/cluster/%s-analytics-%s/useractivitylog", local.project, var.env)

  retention_in_days = var.env == "prod" ? 90 : 30
  skip_destroy      = true
}

resource "aws_cloudwatch_log_group" "userlog" {
  name = format("/aws/redshift/cluster/%s-analytics-%s/userlog", local.project, var.env)

  retention_in_days = var.env == "prod" ? 90 : 30
  skip_destroy      = true
}

resource "aws_redshift_logging" "analytics" {
  depends_on = [aws_cloudwatch_log_group.connectionlog, aws_cloudwatch_log_group.useractivitylog, aws_cloudwatch_log_group.userlog]

  cluster_identifier   = aws_redshift_cluster.analytics.id
  log_destination_type = "cloudwatch"
  log_exports          = ["connectionlog", "useractivitylog", "userlog"]
}

resource "aws_redshift_cluster" "analytics" {
  cluster_identifier = format("%s-analytics-%s", local.project, var.env)
  database_name      = format("%s_%s", local.project, var.env)

  #Workaround because the Redshift's managed secret for the master is not removed when the cluster is deleted.  
  #Issue: https://repost.aws/questions/QUCWqC0PYJS0-zGINN-PEzlw/how-do-we-delete-secrets-manager-secrets-created-by-the-redshift-integration
  master_username = jsondecode(aws_secretsmanager_secret_version.redshift_master.secret_string).username
  master_password = jsondecode(aws_secretsmanager_secret_version.redshift_master.secret_string).password

  cluster_type    = "multi-node"
  number_of_nodes = var.redshift_cluster_nodes_number
  node_type       = var.redshift_cluster_nodes_type

  cluster_subnet_group_name = aws_redshift_subnet_group.analytics.name
  multi_az                  = true
  vpc_security_group_ids    = [aws_security_group.analytics.id]

  publicly_accessible = false
  port                = var.redshift_cluster_port

  cluster_parameter_group_name = aws_redshift_parameter_group.analytics.name

  encrypted  = true
  kms_key_id = aws_kms_key.analytics.arn

  enhanced_vpc_routing = true

  allow_version_upgrade = false

  skip_final_snapshot = true
}

resource "aws_redshift_cluster_iam_roles" "analytics" {
  cluster_identifier = aws_redshift_cluster.analytics.cluster_identifier
  iam_role_arns      = [aws_iam_role.generated_jwt_loader.arn]
}
