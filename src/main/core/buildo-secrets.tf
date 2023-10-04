resource "aws_secretsmanager_secret" "postgres_db_username_refactor" {
  count = var.env == "dev" ? 1 : 0

  name = "postgres-db-username-refactor"
}

resource "aws_secretsmanager_secret" "postgres_db_password_refactor" {
  count = var.env == "dev" ? 1 : 0

  name = "postgres-db-password-refactor"
}

resource "aws_secretsmanager_secret" "debezium_credentials" {
  count = var.env == "dev" ? 1 : 0

  name = "persistence-management-debezium-credentials"
}

resource "aws_secretsmanager_secret" "docdb_username_refactor" {
  count = var.env == "dev" ? 1 : 0

  name = "documentdb-username-refactor"
}

resource "aws_secretsmanager_secret" "docdb_password_refactor" {
  count = var.env == "dev" ? 1 : 0

  name = "documentdb-password-refactor"
}
