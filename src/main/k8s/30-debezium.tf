data "aws_iam_role" "debezium_postgresql" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = var.debezium_postgresql_role_name
}

resource "kubernetes_config_map_v1" "kafka_connect_distributed" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  metadata {
    namespace = var.env == "dev" ? kubernetes_namespace_v1.dev_refactor[0].metadata[0].name : kubernetes_namespace_v1.env.metadata[0].name
    name      = "kafka-connect-distributed"
  }

  data = {
    BOOTSTRAP_SERVERS                         = "boot-yqksbq44.c3.kafka-serverless.eu-central-1.amazonaws.com:9098"
    GROUP_ID                                  = "experimental.debezium.postgresql"
    CONFIG_STORAGE_TOPIC                      = "experimental.debezium.postgresql.config"
    STATUS_STORAGE_TOPIC                      = "experimental.debezium.postgresql.status"
    OFFSET_STORAGE_TOPIC                      = "experimental.debezium.postgresql.offset"
    CONNECT_CONFIG_STORAGE_REPLICATION_FACTOR = "3"
    CONNECT_STATUS_STORAGE_REPLICATION_FACTOR = "3"
    CONNECT_OFFSET_STORAGE_REPLICATION_FACTOR = "3"
    CONNECT_LISTENERS                         = "http://0.0.0.0:8083"
    CONNECT_PLUGIN_PATH                       = "/kafka/connect"
    CONNECT_KEY_CONVERTER_SCHEMAS_ENABLE      = "false"
    CONNECT_VALUE_CONVERTER_SCHEMAS_ENABLE    = "false"

    CONNECT_SECURITY_PROTOCOL                  = "SASL_SSL"
    CONNECT_SASL_MECHANISM                     = "AWS_MSK_IAM"
    CONNECT_SASL_JAAS_CONFIG                   = "software.amazon.msk.auth.iam.IAMLoginModule required;"
    CONNECT_SASL_CLIENT_CALLBACK_HANDLER_CLASS = "software.amazon.msk.auth.iam.IAMClientCallbackHandler"
    # CONNECT_SSL_TRUSTSTORE_LOCATION= /opt/ssl/kafka.client.truststore.jks

    CONNECT_PRODUCER_SECURITY_PROTOCOL                  = "SASL_SSL"
    CONNECT_PRODUCER_SASL_MECHANISM                     = "AWS_MSK_IAM"
    CONNECT_PRODUCER_SASL_JAAS_CONFIG                   = "software.amazon.msk.auth.iam.IAMLoginModule required;"
    CONNECT_PRODUCER_SASL_CLIENT_CALLBACK_HANDLER_CLASS = "software.amazon.msk.auth.iam.IAMClientCallbackHandler"
    # CONNECT_PRODUCER_SSL_TRUSTSTORE_LOCATION= /opt/ssl/kafka.client.truststore.jks

    CONNECT_CONSUMER_SECURITY_PROTOCOL                  = "SASL_SSL"
    CONNECT_CONSUMER_SASL_MECHANISM                     = "AWS_MSK_IAM"
    CONNECT_CONSUMER_SASL_JAAS_CONFIG                   = "software.amazon.msk.auth.iam.IAMLoginModule required;"
    CONNECT_CONSUMER_SASL_CLIENT_CALLBACK_HANDLER_CLASS = "software.amazon.msk.auth.iam.IAMClientCallbackHandler"
    # CONNECT_CONSUMER_SSL_TRUSTSTORE_LOCATION= /opt/ssl/kafka.client.truststore.jks
  }
}

resource "kubernetes_config_map_v1" "debezium_postgresql" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  metadata {
    namespace = var.env == "dev" ? kubernetes_namespace_v1.dev_refactor[0].metadata[0].name : kubernetes_namespace_v1.env.metadata[0].name
    name      = "debezium-postgresql"
  }

  data = {
    CONNECTOR_CONFIG_PATH = "/etc/debezium/connector.json"
    "connector.json" : <<-EOT
      {
        "name": "debezium-postgresql",
         "config": {
            "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
            "tasks.max": 1,
            "database.hostname": "interop-persistence-management-dev.cluster-c9zr6t2swdpb.eu-central-1.rds.amazonaws.com",
            "database.port": "5432",
            "database.user": "debezium_user",
            "database.password": "bYJ%nWMYd859%^Tx",
            "database.dbname": "persistence_management_refactor",
            "topic.prefix": "experimental.event-store",
            "plugin.name": "pgoutput",
            "binary.handling.mode": "hex",
            "slot.name": "debezium_postgresql",
            "publication.name": "events_publication",
            "publication.autocreate.mode": "disabled",
            "transforms": "PartitionRouting",
            "transforms.PartitionRouting.type": "io.debezium.transforms.partitions.PartitionRouting",
            "transforms.PartitionRouting.partition.payload.fields": "change.stream_id",
            "transforms.PartitionRouting.partition.topic.num": 3,
            "table.include.list": "experimental.events"
         }
      }
    EOT
  }
}

resource "kubernetes_service_account_v1" "debezium_postgresql" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  metadata {
    namespace = var.env == "dev" ? kubernetes_namespace_v1.dev_refactor[0].metadata[0].name : kubernetes_namespace_v1.env.metadata[0].name
    name      = "debezium-postgresql"

    labels = {
      app = "debezium-postgresql"
    }

    annotations = {
      "eks.amazonaws.com/role-arn" = data.aws_iam_role.debezium_postgresql[0].arn
    }
  }
}

resource "kubernetes_deployment_v1" "debezium_postgresql" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  metadata {
    namespace = var.env == "dev" ? kubernetes_namespace_v1.dev_refactor[0].metadata[0].name : kubernetes_namespace_v1.env.metadata[0].name
    name      = "debezium-postgresql"

    labels = {
      app = "debezium-postgresql"
    }
  }

  spec {
    replicas = var.debezium_postgresql_replicas

    selector {
      match_labels = {
        app = "debezium-postgresql"
      }
    }

    template {
      metadata {
        labels = {
          app = "debezium-postgresql"
        }
      }

      spec {
        service_account_name = kubernetes_service_account_v1.debezium_postgresql[0].metadata[0].name

        volume {
          name = "connector-config"

          config_map {
            name = kubernetes_config_map_v1.debezium_postgresql[0].metadata[0].name
          }
        }

        container {
          name  = "debezium-postgresql"
          image = var.debezium_postgresql_image_uri

          volume_mount {
            name       = "connector-config"
            mount_path = "/etc/debezium/connector.json"
            sub_path   = "connector.json"
          }

          env_from {
            config_map_ref {
              name = kubernetes_config_map_v1.kafka_connect_distributed[0].metadata[0].name
            }
          }

          env {
            name  = "HEAP_OPTS"
            value = "-Xms256M -Xmx2G"
          }

          env {
            name = "CONNECTOR_CONFIG_PATH"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map_v1.debezium_postgresql[0].metadata[0].name
                key  = "CONNECTOR_CONFIG_PATH"
              }
            }
          }

          liveness_probe {
            exec {
              command = ["/bin/bash", "/liveness.sh"]
            }

            initial_delay_seconds = 45
            period_seconds        = 5
          }

          readiness_probe {
            exec {
              command = ["/bin/bash", "/liveness.sh"]
            }

            initial_delay_seconds = 45
            period_seconds        = 5
          }

          resources {
            requests = {
              cpu    = var.debezium_postgresql_cpu
              memory = var.debezium_postgresql_memory
            }

            limits = {
              cpu    = var.debezium_postgresql_cpu
              memory = var.debezium_postgresql_memory
            }
          }
        }
      }
    }
  }
}
