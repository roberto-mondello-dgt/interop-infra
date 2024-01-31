module "be_refactor_application_documents_bucket" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = format("interop-application-documents-refactor-%s", var.env)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }
}
