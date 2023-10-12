data "aws_iam_policy" "transfer_logging" {
  name = "AWSTransferLoggingAccess"
}

resource "aws_iam_role" "sftp_anac_logging" {
  name = format("InteropSftpAnacLogging%s", title(var.env))

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "transfer.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  managed_policy_arns = [data.aws_iam_policy.transfer_logging.arn]
}

resource "aws_transfer_server" "sftp_anac" {
  endpoint_type          = "PUBLIC"
  protocols              = ["SFTP"]
  identity_provider_type = "SERVICE_MANAGED"
  domain                 = "S3"
  logging_role           = aws_iam_role.sftp_anac_logging.arn
}

resource "aws_iam_role" "sftp_anac_readonly" {
  name = format("InteropSftpAnacS3%s", title(var.env))

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "transfer.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  inline_policy {
    name = "S3ReadOnly"

    policy = jsonencode({
      Version : "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = "s3:ListBucket"
          Resource = module.anac_sftp_bucket.s3_bucket_arn
        },
        {
          Effect = "Allow"
          Action = "s3:Get*"
          Resource = [
            module.anac_sftp_bucket.s3_bucket_arn,
            "${module.anac_sftp_bucket.s3_bucket_arn}/*"
          ]
      }]
    })
  }
}

resource "aws_transfer_user" "anac_certified_attributes_importer" {
  user_name = "interop-anac-certified-attributes-importer"
  server_id = aws_transfer_server.sftp_anac.id
  role      = aws_iam_role.sftp_anac_readonly.arn

  home_directory_type = "LOGICAL"

  home_directory_mappings {
    entry  = "/"
    target = "/${module.anac_sftp_bucket.s3_bucket_id}"
  }
}

resource "aws_transfer_ssh_key" "anac_certified_attributes_importer" {
  server_id = aws_transfer_server.sftp_anac.id
  user_name = aws_transfer_user.anac_certified_attributes_importer.user_name

  body = file("${path.module}/assets/ssh-public-keys/interop-anac-certified-attributes-importer-${var.env}.pub")
}
