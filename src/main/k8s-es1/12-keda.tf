locals {
  keda_components_resources = {
    operator = {
      requests = {
        cpu    = var.keda_operator_resources_limits_cpu
        memory = var.keda_operator_resources_limits_memory
      },
      limits = {
        cpu    = var.keda_operator_resources_limits_cpu
        memory = var.keda_operator_resources_limits_memory
      }
    },
    metricServer = {
      requests = {
        cpu    = var.keda_metrics_server_resources_limits_cpu
        memory = var.keda_metrics_server_resources_limits_memory
      },
      limits = {
        cpu    = var.keda_metrics_server_resources_limits_cpu
        memory = var.keda_metrics_server_resources_limits_memory
      }
    },
    webhooks = {
      requests = {
        cpu    = var.keda_webhooks_resources_limits_cpu
        memory = var.keda_webhooks_resources_limits_memory
      },
      limits = {
        cpu    = var.keda_webhooks_resources_limits_cpu
        memory = var.keda_webhooks_resources_limits_memory
      }
    }
  }
  flattened_keda_components_resources = flatten([
    for component, resource_types in local.keda_components_resources : [
      for type, values in resource_types : [
        for key, val in values : {
          name  = "resources.${component}.${type}.${key}"
          value = val
        }
      ]
    ]
  ])
}

resource "helm_release" "keda" {
  count = local.deploy_keda ? 1 : 0

  name       = "keda"
  repository = "https://kedacore.github.io/charts"
  chart      = "keda"
  version    = var.keda_chart_version
  namespace  = kubernetes_namespace_v1.keda.metadata[0].name

  dynamic "set" {
    for_each = local.flattened_keda_components_resources

    content {
      name  = set.value.name
      value = set.value.value
    }
  }
}
