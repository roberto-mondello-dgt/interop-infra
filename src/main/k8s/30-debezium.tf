data "aws_iam_role" "debezium_postgresql" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = var.debezium_postgresql_role_name
}

# msk_serverless_cluster TF resource doesn't expose the bootstrap servers attribute
data "external" "msk_bootstrap_servers" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  program = ["aws", "kafka", "get-bootstrap-brokers",
  "--cluster-arn", "${var.debezium_postgresql_msk_cluster_arn}"]
}

data "aws_rds_cluster" "event_store" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  cluster_identifier = var.debezium_postgresql_aurora_cluster_id
}

data "aws_secretsmanager_secret" "debezium_credentials" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  name = var.debezium_postgresql_credentials_secret_name
}

resource "kubernetes_config_map_v1" "kafka_connect_distributed" {
  count = local.deploy_be_refactor_infra ? 1 : 0

  metadata {
    namespace = var.env == "dev" ? kubernetes_namespace_v1.dev_refactor[0].metadata[0].name : kubernetes_namespace_v1.env.metadata[0].name
    name      = "kafka-connect-distributed"
  }

  data = {
    BOOTSTRAP_SERVERS                         = data.external.msk_bootstrap_servers[0].result.BootstrapBrokerStringSaslIam
    GROUP_ID                                  = "debezium.postgresql"
    CONFIG_STORAGE_TOPIC                      = "__debezium.postgresql.config"
    STATUS_STORAGE_TOPIC                      = "__debezium.postgresql.status"
    OFFSET_STORAGE_TOPIC                      = "__debezium.postgresql.offset"
    CONNECT_CONFIG_STORAGE_REPLICATION_FACTOR = "3"
    CONNECT_STATUS_STORAGE_REPLICATION_FACTOR = "3"
    CONNECT_OFFSET_STORAGE_REPLICATION_FACTOR = "3"
    CONNECT_LISTENERS                         = "http://0.0.0.0:8083"
    CONNECT_PLUGIN_PATH                       = "/kafka/connect"
    CONNECT_KEY_CONVERTER_SCHEMAS_ENABLE      = "false"
    CONNECT_VALUE_CONVERTER_SCHEMAS_ENABLE    = "false"
    CONNECT_CONNECTIONS_MAX_IDLE_MS           = "540000"

    CONNECT_CONFIG_PROVIDERS                             = "secretsmanager"
    CONNECT_CONFIG_PROVIDERS_SECRETSMANAGER_CLASS        = "com.amazonaws.kafka.config.providers.SecretsManagerConfigProvider"
    CONNECT_CONFIG_PROVIDERS_SECRETSMANAGER_PARAM_REGION = var.aws_region

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

locals {
  debezium_include_schema_prefix = var.env == "dev" ? "dev-refactor" : var.env
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
           "database.hostname": "${data.aws_rds_cluster.event_store[0].endpoint}",
           "database.port": "${data.aws_rds_cluster.event_store[0].port}",
           "database.user": "$${secretsmanager:${data.aws_secretsmanager_secret.debezium_credentials[0].name}:username}",
           "database.password": "$${secretsmanager:${data.aws_secretsmanager_secret.debezium_credentials[0].name}:password}",
           "database.dbname": "${var.debezium_postgresql_database_name}",
           "topic.prefix": "event-store",
           "plugin.name": "pgoutput",
           "binary.handling.mode": "hex",
           "slot.name": "debezium_postgresql",
           "publication.name": "events_publication",
           "publication.autocreate.mode": "disabled",
           "transforms": "PartitionRouting",
           "transforms.PartitionRouting.type": "io.debezium.transforms.partitions.PartitionRouting",
           "transforms.PartitionRouting.partition.payload.fields": "change.stream_id",
           "transforms.PartitionRouting.partition.topic.num": 3,
           "message.key.columns": "${local.debezium_include_schema_prefix}_(.*).events:stream_id",
           "table.include.list": "${local.debezium_include_schema_prefix}_.*\\.events",
           "heartbeat.interval.ms": 30000,
           "topic.heartbeat.prefix": "__debezium.postgresql.heartbeat",
           "heartbeat.action.query": "INSERT INTO \"${local.debezium_include_schema_prefix}_debezium\".\"heartbeat\" VALUES ('debezium_postgresql', now()) ON CONFLICT (slot_name) DO UPDATE SET latest_heartbeat = now();"
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
