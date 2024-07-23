module "be_refactor_persistence_events_queue" {
  count = var.env == "dev" ? 1 : 0

  source  = "terraform-aws-modules/sqs/aws"
  version = "4.0.2"

  name       = "persistence-events-refactor.fifo"
  fifo_queue = true

  sqs_managed_sse_enabled = false

  visibility_timeout_seconds = 10
  max_message_size           = 262144
  message_retention_seconds  = 1209600
  receive_wait_time_seconds  = 1
  deduplication_scope        = "messageGroup"
  fifo_throughput_limit      = "perMessageGroupId"
}

module "be_refactor_persistence_events_queue_monitoring" {
  count = var.env == "dev" ? 1 : 0

  source     = "./modules/queue-monitoring"
  depends_on = [module.be_refactor_persistence_events_queue]

  env                     = var.env
  region                  = var.aws_region
  queue_name              = module.be_refactor_persistence_events_queue[0].queue_name
  alarm_threshold_seconds = "1800" # 30 minutes
  alarm_sns_topic_arn     = aws_sns_topic.be_refactor_platform_alarms[0].arn
}

module "be_refactor_generated_jwt_queue" {
  count = var.env == "dev" ? 1 : 0

  source  = "terraform-aws-modules/sqs/aws"
  version = "4.0.2"

  name = "generated-jwt-refactor"

  sqs_managed_sse_enabled = false

  visibility_timeout_seconds = 30
  max_message_size           = 262144
  message_retention_seconds  = 1209600
}

module "be_refactor_archived_agreements_for_purposes_queue" {
  count = var.env == "dev" ? 1 : 0

  source  = "terraform-aws-modules/sqs/aws"
  version = "4.0.2"

  name = "archived-agreements-for-purposes-refactor"

  sqs_managed_sse_enabled = false

  visibility_timeout_seconds = 30
  max_message_size           = 262144
  message_retention_seconds  = 1209600
}

module "be_refactor_archived_agreements_for_eservices_queue" {
  count = var.env == "dev" ? 1 : 0

  source  = "terraform-aws-modules/sqs/aws"
  version = "v4.0.2"

  name = "archived-agreements-for-eservices-refactor"

  sqs_managed_sse_enabled = false

  visibility_timeout_seconds = 30
  max_message_size           = 262144
  message_retention_seconds  = 1209600
}

module "be_refactor_certified_mail_queue" {
  count = var.env == "dev" ? 1 : 0

  source  = "terraform-aws-modules/sqs/aws"
  version = "4.0.2"

  name       = "certified-mail-refactor.fifo"
  fifo_queue = true

  sqs_managed_sse_enabled = false

  visibility_timeout_seconds = 30
  max_message_size           = 262144
  message_retention_seconds  = 1209600

  content_based_deduplication = true
  deduplication_scope         = "queue"
  fifo_throughput_limit       = "perQueue"
}
