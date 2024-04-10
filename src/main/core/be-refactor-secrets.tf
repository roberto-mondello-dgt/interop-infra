resource "aws_secretsmanager_secret" "debezium_credentials" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = "persistence-management-debezium-credentials"
}

resource "aws_secretsmanager_secret" "postgres_db_username_refactor" {
  count = var.env == "dev" ? 1 : 0

  name = "postgres-db-username-refactor"
}

resource "aws_secretsmanager_secret" "postgres_db_password_refactor" {
  count = var.env == "dev" ? 1 : 0

  name = "postgres-db-password-refactor"
}

resource "aws_secretsmanager_secret" "docdb_ro_username_refactor" {
  count = var.env == "dev" ? 1 : 0

  name = "documentdb-ro-username-refactor"
}

resource "aws_secretsmanager_secret" "docdb_ro_password_refactor" {
  count = var.env == "dev" ? 1 : 0

  name = "documentdb-ro-password-refactor"
}

resource "aws_secretsmanager_secret" "docdb_projection_username_refactor" {
  count = var.env == "dev" ? 1 : 0

  name = "documentdb-projection-username-refactor"
}

resource "aws_secretsmanager_secret" "docdb_projection_password_refactor" {
  count = var.env == "dev" ? 1 : 0

  name = "documentdb-projection-password-refactor"
}

resource "aws_secretsmanager_secret" "flyway_event_store_username" {
  count = var.env == "dev" ? 1 : 0

  name = "flyway-event-store-username"
}

resource "aws_secretsmanager_secret" "flyway_event_store_password" {
  count = var.env == "dev" ? 1 : 0

  name = "flyway-event-store-password"
}

resource "aws_secretsmanager_secret" "selfcare_api_key_refactor" {
  count = var.env == "dev" ? 1 : 0

  name = "selfcare-api-key-refactor"
}
