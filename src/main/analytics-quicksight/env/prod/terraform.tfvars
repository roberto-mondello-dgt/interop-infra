aws_region = "eu-south-1"
env        = "prod"

tags = {
  CreatedBy   = "Terraform"
  Environment = "prod"
  Owner       = "PagoPA"
  Source      = "https://github.com/pagopa/interop-infra"
}

vpc_id               = "vpc-0c08ca99a78bc66fc"
analytics_subnet_ids = ["subnet-0872428e8ba3b6367", "subnet-0015a3c56e67e8e3b", "subnet-0a39cd632de1fc94e"]

quicksight_identity_center_arn    = "arn:aws:sso:::instance/ssoins-6804d580c9a0bfbc"
quicksight_identity_center_region = "eu-west-1"

quicksight_notification_email = "pdnd-interop+prod@pagopa.it"

quicksight_analytics_security_group_name   = "quicksight/interop-analytics-prod"
quicksight_redshift_user_credential_secret = "redshift/interop-analytics-prod/users/interop_analytics_quicksight_user"
redshift_cluster_identifier                = "interop-analytics-prod"
