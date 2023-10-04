module "application_documents_refactor_bucket" {
  count = var.env == "dev" ? 1 : 0

  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.14.1"

  bucket = format("interop-application-documents-refactor-%s", var.env)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }
}

module "msk_custom_plugins_bucket" {
  count = var.env == "dev" ? 1 : 0

  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.14.1"

  bucket = format("interop-msk-custom-plugins-%s", var.env)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }
}
