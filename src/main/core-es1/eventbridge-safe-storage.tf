resource "aws_cloudwatch_event_bus" "safe_storage_results" {
  count = local.deploy_safe_storage_infra ? 1 : 0

  name = format("interop-safe-storage-results-%s", var.env)
}

data "aws_iam_policy_document" "safe_storage_results" {
  count = local.deploy_safe_storage_infra ? 1 : 0

  statement {
    sid = "SafeStoragePutEvents"

    principals {
      type        = "AWS"
      identifiers = [var.safe_storage_account_id]
    }

    effect = "Allow"
    actions = [
      "events:PutEvents",
    ]
    resources = [aws_cloudwatch_event_bus.safe_storage_results[0].arn]
  }
}

resource "aws_cloudwatch_event_bus_policy" "safe_storage_results" {
  count = local.deploy_safe_storage_infra ? 1 : 0

  event_bus_name = aws_cloudwatch_event_bus.safe_storage_results[0].name
  policy         = data.aws_iam_policy_document.safe_storage_results[0].json
}

resource "aws_cloudwatch_log_group" "safe_storage_results" {
  count = local.deploy_safe_storage_infra ? 1 : 0

  name              = format("/aws/eventbridge/%s", aws_cloudwatch_event_bus.safe_storage_results[0].name)
  retention_in_days = var.env == "prod" ? 90 : 30
}
