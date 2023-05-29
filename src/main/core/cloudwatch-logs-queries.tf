resource "aws_cloudwatch_query_definition" "app_logs_errors" {
  name = "ApplicationLogsErrors"

  log_group_names = [var.eks_application_log_group_name]

  query_string = <<-EOT
    fields @timestamp, @message 
    | sort @timestamp asc
    | filter (@message like /ERROR/ or stream = "stderr")
    | filter @logstream not like /adot-collector/
  EOT
}

resource "aws_cloudwatch_query_definition" "cid_tracker" {
  name = "CIDTracker"

  log_group_names = [var.eks_application_log_group_name]

  query_string = <<-EOT
    fields @timestamp, @message 
    | sort @timestamp asc 
    | parse @message "[CID=*]" as CID 
    | filter CID = "" 
  EOT
}

resource "aws_cloudwatch_query_definition" "waf_blocked_requests" {
  name = "WAFBlockedRequests"

  log_group_names = [aws_cloudwatch_log_group.waf.name]

  query_string = <<-EOT
    fields @timestamp, @message
    | filter action = "BLOCK"
    | sort @timestamp desc
  EOT
}
