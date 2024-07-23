output "iam_user_arn" {
  description = "ARN of the IAM user managed by this module"
  value       = aws_iam_user.this.arn
}

output "iam_user_name" {
  description = "Username of the IAM user managed by this module"
  value       = aws_iam_user.this.name
}

output "smtp_username_secret_arn" {
  description = "ARN of the secret managed by this module containing SMTP username"
  value       = aws_secretsmanager_secret.this_username.arn
}

output "smtp_password_secret_arn" {
  description = "ARN of the secret managed by this module containing SMTP password"
  value       = aws_secretsmanager_secret.this_password.arn
}
