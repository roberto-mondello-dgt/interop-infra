resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}

resource "aws_secretsmanager_secret" "this" {
  name        = "ses/smtp/${aws_iam_user.this.name}"
  description = "Secret containing the STMP credentials to be used to send email via SMTP interface."
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id = aws_secretsmanager_secret.this.id
  secret_string = jsonencode({
    username = aws_iam_access_key.this.id
    password = aws_iam_access_key.this.ses_smtp_password_v4
  })
}