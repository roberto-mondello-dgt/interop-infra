aws_region = "eu-south-1"
env        = "dev"

tags = {
  CreatedBy   = "Terraform"
  Environment = "dev"
  Owner       = "PagoPA"
  Source      = "https://github.com/pagopa/interop-infra"
}

vpc_id               = "vpc-0df5f0ee96b0824c7"
analytics_subnet_ids = ["subnet-0f7445d4c56f10f3b", "subnet-0946493be6a7d2fbd", "subnet-05537a9801f26457c"]

quicksight_identity_center_arn    = "arn:aws:sso:::instance/ssoins-6804d580c9a0bfbc"
quicksight_identity_center_region = "eu-west-1"

quicksight_notification_email = "pdnd-interop+dev@pagopa.it"

quicksight_analytics_security_group_name   = "quicksight/interop-analytics-dev"
quicksight_redshift_user_credential_secret = "redshift/interop-analytics-dev/users/dev_quicksight_user"
redshift_cluster_identifier                = "interop-analytics-dev"
