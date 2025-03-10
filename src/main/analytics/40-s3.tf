resource "aws_s3_bucket_notification" "jwt_audit_source" {
  count = local.deploy_data_ingestion_resources ? 1 : 0

  depends_on = [aws_sqs_queue_policy.jwt_audit[0]]

  bucket = data.aws_s3_bucket.jwt_audit_source.id

  queue {
    queue_arn = aws_sqs_queue.jwt_audit[0].arn
    events    = ["s3:ObjectCreated:Put"]
  }
}

resource "aws_s3_bucket_notification" "alb_logs_source" {
  count = local.deploy_data_ingestion_resources ? 1 : 0

  depends_on = [aws_sqs_queue_policy.alb_logs[0]]

  bucket = data.aws_s3_bucket.alb_logs_source.id

  queue {
    queue_arn = aws_sqs_queue.alb_logs[0].arn
    events    = ["s3:ObjectCreated:Put"]
  }
}
