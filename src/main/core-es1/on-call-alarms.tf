# resource "aws_cloudwatch_metric_alarm" "on_call_token_5xx" {
#   alarm_name = format("on-call-apigw-token-5xx-%s", var.env)
#
#   alarm_actions = [aws_sns_topic.on_call_opsgenie.arn]
#
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   threshold           = 60 # 60%
#   evaluation_periods  = 60 # 60 periods, 1 minute each
#   datapoints_to_alarm = 30 # 30 periods breaching the threshold in the last N evaluation_periods
#   treat_missing_data  = "notBreaching"
#
#   metric_query {
#     id          = "e1"
#     label       = "5xxPercentage"
#     expression  = "(m1/m2)*100"
#     return_data = true
#   }
#
#   metric_query {
#     id          = "m1"
#     label       = "PostToken5xx"
#     return_data = false
#
#     metric {
#       stat        = "Sum"
#       period      = 60 # 1 minute
#       metric_name = "5XXError"
#       namespace   = "AWS/ApiGateway"
#
#       dimensions = {
#         ApiName  = module.interop_auth_apigw.apigw_name
#         Stage    = var.env
#         Method   = "POST"
#         Resource = "/token.oauth2"
#       }
#     }
#   }
#
#   metric_query {
#     id          = "m2"
#     label       = "PostTokenCount"
#     return_data = false
#
#     metric {
#       stat        = "Sum"
#       period      = 60 # 1 minute
#       metric_name = "Count"
#       namespace   = "AWS/ApiGateway"
#
#       dimensions = {
#         ApiName  = module.interop_auth_apigw.apigw_name
#         Stage    = var.env
#         Method   = "POST"
#         Resource = "/token.oauth2"
#       }
#     }
#   }
# }
#
# locals {
#   on_call_deployments = {
#     auth_server     = "interop-be-authorization-server"
#     auth_management = "interop-be-authorization-management"
#   }
# }
#
# resource "aws_cloudwatch_metric_alarm" "on_call_unavailable_pods" {
#   for_each = local.on_call_deployments
#
#   alarm_name        = format("on-call-k8s-%s-unavailable-pods-%s", replace(each.key, "_", "-"), var.env)
#   alarm_description = format("No available pods for %s K8s deployment", each.value)
#
#   alarm_actions = [aws_sns_topic.on_call_opsgenie.arn]
#
#   comparison_operator = "LessThanThreshold"
#   statistic           = "Minimum"
#   threshold           = 1
#   period              = 60 # 1 minute
#   evaluation_periods  = 10 # 10 periods, 1 minute each
#   datapoints_to_alarm = 5  # 5 periods breaching the threshold in the last N evaluation_periods
#   treat_missing_data  = "missing"
#
#   metric_name = "kube_deployment_status_replicas_available"
#   namespace   = "ContainerInsights"
#
#   dimensions = {
#     ClusterName = module.eks.cluster_name
#     Service     = each.value
#     Namespace   = var.env
#   }
# }
