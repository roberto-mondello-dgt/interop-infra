module "openapi" {
  count = var.openapi_s3_bucket_name != null && var.openapi_s3_object_key != null ? 1 : 0

  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = format("interop-%s-%s-es1", var.openapi_s3_bucket_name, var.env)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }
}

resource "aws_s3_object" "openapi" {
  depends_on = [data.external.openapi_integration]

  count = var.openapi_s3_bucket_name != null && var.openapi_s3_object_key != null ? 1 : 0

  bucket = module.openapi[0].s3_bucket_id
  key    = var.openapi_s3_object_key

  content = data.external.openapi_integration.result.integrated_openapi_yaml

  source_hash = sha256(data.external.openapi_integration.result.integrated_openapi_yaml)
}