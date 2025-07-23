module "signed_object_persister_safe_storage_events_queue" {
  count = local.deploy_safe_storage_event_queues ? 1 : 0

  source  = "terraform-aws-modules/sqs/aws"
  version = "4.2.1"

  name = format("%s-safe-storage-completed-tasks-%s", local.project, var.env)

  visibility_timeout_seconds = 30
  message_retention_seconds  = 1209600 # 14 days
  max_message_size           = 262144  # 256 KB

  sqs_managed_sse_enabled = false

  create_queue_policy = true
  queue_policy_statements = {
    sns = {
      sid    = "subscription_can_write"
      effect = "Allow"

      principals = [{
        type        = "Service"
        identifiers = ["sns.amazonaws.com"]
      }]

      actions = [
        "sqs:SendMessage",
      ]

      conditions = [{
        test     = "ForAllValues:ArnEquals"
        variable = "aws:SourceArn"

        values = local.signed_object_persister_queue_subscribed_topics
      }]
    }
  }
}

locals {
  # - If the feature is disabled this list is empty
  signed_object_persister_queue_subscribed_topics = local.deploy_safe_storage_event_queues ? [
    # This list is hardcoded because:
    #   is the same in any environment and
    #   any change require change in microservices architecture and .
    for topic_user in ["document-signer", "event-signer", "audit-signer", "signed-object-persister"] :
    format(
      "arn:aws:sns:%s:%s:safe_storage_client_%s-%s-%s",
      var.aws_region,
      var.safe_storage_account_id,
      local.project,
      var.env,
      topic_user
    )
  ] : []
}

resource "aws_sns_topic_subscription" "safe_storage_events_subscription" {
  for_each = toset(local.signed_object_persister_queue_subscribed_topics)

  topic_arn            = each.value
  protocol             = "sqs"
  endpoint             = module.signed_object_persister_safe_storage_events_queue[0].queue_arn
  raw_message_delivery = true
}

module "signed_object_persister_safe_storage_events_queue_monitoring" {
  count = local.deploy_safe_storage_event_queues ? 1 : 0
  depends_on = [
    module.signed_object_persister_safe_storage_events_queue[0]
  ]

  source = "./modules/queue-monitoring"

  env                      = var.env
  region                   = var.aws_region
  queue_name               = module.signed_object_persister_safe_storage_events_queue[0].queue_name
  alarm_threshold_seconds  = 1 * 60 * 60 # 60 minutes, 1 hour
  alarm_evaluation_periods = 5
  alarm_sns_topic_arn      = aws_sns_topic.platform_alarms.arn
}
