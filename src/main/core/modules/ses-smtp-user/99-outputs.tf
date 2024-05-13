output "iam_user_arn" {
  description = "ARN of the IAM user managed by this module"
  value       = aws_iam_user.this.arn
}

output "iam_user_name" {
  description = "Username of the IAM user managed by this module"
  value       = aws_iam_user.this.name
}

output "secretsmanager_secret_id" {
  description = "ID of the secret managed by this module"
  value       = aws_secretsmanager_secret.this.arn
}

output "secretsmanager_secret_arn" {
  description = "ARN of the secret managed by this module"
  value       = aws_secretsmanager_secret.this.arn
}