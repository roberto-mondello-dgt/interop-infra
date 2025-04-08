locals {
  deploy_auth_server_canary_ingress = var.env != "qa" && var.env != "att"
  auth_server_canary_weights = {
    old = {
      dev  = 0
      qa   = 0
      vapt = 0
      test = 0
      att  = 100
      prod = 99
    }
    new = {
      dev  = 100
      qa   = 100
      vapt = 100
      test = 100
      att  = 0
      prod = 1
    }
  }
}

import {
  for_each = var.env != "vapt" ? [1] : [] # this configurations creates the ingress for the first time only in VAPT env

  id = format("%s/interop-be-authorization-server-canary", kubernetes_namespace_v1.env.metadata[0].name)
  to = kubernetes_ingress_v1.auth_server_canary[0]
}

resource "kubernetes_ingress_v1" "auth_server_canary" {
  count = local.deployment_repo_v2_active ? 1 : 0

  metadata {
    name      = "interop-be-authorization-server-canary"
    namespace = kubernetes_namespace_v1.env.metadata[0].name

    annotations = {
      "alb.ingress.kubernetes.io/scheme"                       = "internal"
      "alb.ingress.kubernetes.io/target-type"                  = "ip"
      "alb.ingress.kubernetes.io/group.name"                   = "interop-be"
      "alb.ingress.kubernetes.io/group.order"                  = "0"
      "alb.ingress.kubernetes.io/target-group-attributes"      = "deregistration_delay.timeout_seconds=31"
      "alb.ingress.kubernetes.io/healthcheck-interval-seconds" = "5"
      "alb.ingress.kubernetes.io/healthcheck-timeout-seconds"  = "4"
      "alb.ingress.kubernetes.io/load-balancer-attributes"     = "routing.http.preserve_host_header.enabled=true"
      "alb.ingress.kubernetes.io/actions.auth-server-canary"   = <<-EOT
        {
          "type":"forward",
          "forwardConfig":{
            "targetGroups":[
              {
                "serviceName": "interop-be-authorization-server",
                "servicePort": "8088",
                "weight": ${local.auth_server_canary_weights.old[var.env]}
              },
              {
                "serviceName": "interop-be-authorization-server-node",
                "servicePort": "8088",
                "weight": ${local.auth_server_canary_weights.new[var.env]}
              }
            ]
          }
        }
        EOT
    }
  }

  spec {
    ingress_class_name = "alb"

    rule {
      host = var.env == "prod" ? "*.interop.pagopa.it" : "*.${var.env}.interop.pagopa.it"

      http {
        path {
          path      = "/authorization-server"
          path_type = "Prefix"

          backend {
            service {
              name = "auth-server-canary"

              port {
                name = "use-annotation"
              }
            }
          }
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [metadata[0].annotations["alb.ingress.kubernetes.io/actions.auth-server-canary"]]
  }
}

import {
  for_each = var.env != "vapt" ? [1] : [] # this configurations creates the ingress for the first time only in VAPT env

  id = format("%s/interop-services", kubernetes_namespace_v1.env.metadata[0].name)
  to = kubernetes_ingress_v1.interop_services[0]
}

resource "kubernetes_ingress_v1" "interop_services" {
  count = local.deployment_repo_v2_active ? 1 : 0

  metadata {
    name      = "interop-services"
    namespace = kubernetes_namespace_v1.env.metadata[0].name

    annotations = {
      "alb.ingress.kubernetes.io/scheme"                       = "internal"
      "alb.ingress.kubernetes.io/target-type"                  = "ip"
      "alb.ingress.kubernetes.io/group.name"                   = "interop-be"
      "alb.ingress.kubernetes.io/group.order"                  = "1"
      "alb.ingress.kubernetes.io/target-group-attributes"      = "deregistration_delay.timeout_seconds=31"
      "alb.ingress.kubernetes.io/healthcheck-interval-seconds" = "5"
      "alb.ingress.kubernetes.io/healthcheck-timeout-seconds"  = "4"
      "alb.ingress.kubernetes.io/load-balancer-attributes"     = "routing.http.preserve_host_header.enabled=true"
    }
  }

  spec {
    ingress_class_name = "alb"

    rule {
      host = var.env == "prod" ? "*.interop.pagopa.it" : "*.${var.env}.interop.pagopa.it"

      http {
        path {
          path      = "/api-gateway"
          path_type = "Prefix"

          backend {

            service {
              name = "interop-be-api-gateway"

              port {
                number = 8088
              }
            }
          }
        }
      }
    }

    rule {
      host = var.env == "prod" ? "*.interop.pagopa.it" : "*.${var.env}.interop.pagopa.it"

      http {
        path {
          path      = "/authorization-server"
          path_type = "Prefix"

          backend {

            service {
              name = "interop-be-authorization-server"

              port {
                number = 8088
              }
            }
          }
        }
      }
    }

    rule {
      host = var.env == "prod" ? "*.interop.pagopa.it" : "*.${var.env}.interop.pagopa.it"

      http {
        path {
          path      = "/backend-for-frontend"
          path_type = "Prefix"

          backend {

            service {
              name = "interop-be-backend-for-frontend"

              port {
                number = 8088
              }
            }
          }
        }
      }
    }

    rule {
      host = var.env == "prod" ? "*.interop.pagopa.it" : "*.${var.env}.interop.pagopa.it"

      http {
        path {
          path      = "/ui"
          path_type = "Prefix"

          backend {

            service {
              name = "interop-frontend"

              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

data "kubernetes_ingress_v1" "existing" {
  metadata {
    name      = "interop-be-authorization-server-canary"
    namespace = "dev"
  }
}

output "existing" {
  value = data.kubernetes_ingress_v1.existing.metadata
}
