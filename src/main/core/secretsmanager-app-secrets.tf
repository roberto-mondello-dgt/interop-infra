resource "aws_secretsmanager_secret" "postgres_db_username" {
  name = "postgres-db-username"
}

resource "aws_secretsmanager_secret" "postgres_db_password" {
  name = "postgres-db-password"
}

resource "aws_secretsmanager_secret" "docdb_admin_username" {
  name = "documentdb-admin-username"
}

resource "aws_secretsmanager_secret" "docdb_admin_password" {
  name = "documentdb-admin-password"
}

resource "aws_secretsmanager_secret" "docdb_projection_username" {
  name = "documentdb-projection-username"
}

resource "aws_secretsmanager_secret" "docdb_projection_password" {
  name = "documentdb-projection-password"
}

resource "aws_secretsmanager_secret" "docdb_ro_username" {
  name = "documentdb-ro-username"
}

resource "aws_secretsmanager_secret" "docdb_ro_password" {
  name = "documentdb-ro-password"
}

resource "aws_secretsmanager_secret" "user_registry_api_key" {
  name = "user-registry-api-key"
}

resource "aws_secretsmanager_secret" "party_process_api_key" {
  name = "party-process-api-key"
}

resource "aws_secretsmanager_secret" "party_management_api_key" {
  name = "party-management-api-key"
}

resource "aws_secretsmanager_secret" "pec_username" {
  name = "interop-pec-user"
}

resource "aws_secretsmanager_secret" "pec_password" {
  name = "interop-pec-password"
}

resource "aws_secretsmanager_secret" "selfcare_api_key" {
  name = "selfcare-api-key"
}

resource "aws_secretsmanager_secret" "selfcare_broker_connection_string" {
  name = "selfcare-broker-connection-string"
}

resource "aws_secretsmanager_secret" "metrics_reports_recipients" {
  name = "metrics-reports-recipients"
}

resource "aws_secretsmanager_secret" "metrics_reports_smtp_username" {
  name = "metrics-reports-smtp-username"
}

resource "aws_secretsmanager_secret" "metrics_reports_smtp_password" {
  name = "metrics-reports-smtp-password"
}

resource "aws_secretsmanager_secret" "onetrust_client_id" {
  name = "onetrust-clientid"
}

resource "aws_secretsmanager_secret" "onetrust_client_secret" {
  name = "onetrust-clientsecret"
}

resource "aws_secretsmanager_secret" "pec_sender" {
  name = "interop-pec-sender"
}