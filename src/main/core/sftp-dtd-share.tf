data "aws_iam_policy" "transfer_logging" {
  name = "AWSTransferLoggingAccess"
}

resource "aws_iam_role" "dtd_share_logging" {
  name = format("InteropDtdShareLogging%s", var.env)

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

resource "aws_transfer_server" "dtd_share" {
  endpoint_type          = "PUBLIC"
  protocols              = ["SFTP"]
  identity_provider_type = "SERVICE_MANAGED"
  domain                 = "S3"
  logging_role           = aws_iam_role.dtd_share_logging.arn

  tags = {
    "transfer:route53HostedZoneId" = format("/hostedzone/%s", aws_route53_zone.interop_public.zone_id)
    "transfer:customHostname"      = var.dtd_share_sftp_hostname
  }
}

resource "aws_route53_record" "dtd_share" {
  zone_id = aws_route53_zone.interop_public.zone_id
  name    = var.dtd_share_sftp_hostname
  type    = "CNAME"
  records = toset([aws_transfer_server.dtd_share.endpoint])
  ttl     = "300"
}

resource "aws_iam_role" "dtd_share_s3" {
  name = format("InteropDtdShareS3%s", var.env)

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
          Resource = module.dtd_share_bucket.s3_bucket_arn
        },
        {
          Effect = "Allow"
          Action = "s3:Get*"
          Resource = [
            module.dtd_share_bucket.s3_bucket_arn,
            "${module.dtd_share_bucket.s3_bucket_arn}/*"
          ]
      }]
    })
  }
}
