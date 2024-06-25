resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}

resource "aws_secretsmanager_secret" "this_username" {
  name = "ses/smtp/${aws_iam_user.this.name}/username"
}

resource "aws_secretsmanager_secret" "this_password" {
  name = "ses/smtp/${aws_iam_user.this.name}/password"
}

resource "aws_secretsmanager_secret_version" "this_username" {
  secret_id     = aws_secretsmanager_secret.this_username.id
  secret_string = aws_iam_access_key.this.id
}

resource "aws_secretsmanager_secret_version" "this_password" {
  secret_id     = aws_secretsmanager_secret.this_password.id
  secret_string = aws_iam_access_key.this.ses_smtp_password_v4
}
