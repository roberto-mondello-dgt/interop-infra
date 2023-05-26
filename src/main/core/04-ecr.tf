locals {
  is_prod = var.env == "prod"
  repository_name = [
    "interop-be-agreement-management",
    "interop-be-agreement-process",
    "interop-be-api-gateway",
    "interop-be-attribute-registry-management",
    "interop-be-attribute-registry-process",
    "interop-be-attributes-loader",
    "interop-be-authorization-management",
    "interop-be-authorization-process",
    "interop-be-authorization-server",
    "interop-be-backend-for-frontend",
    "interop-be-catalog-management",
    "interop-be-catalog-process",
    "interop-be-certified-mail-sender",
    "interop-be-dashboard-metrics-report-generator",
    "interop-be-dtd-catalog-exporter",
    "interop-be-eservices-monitoring-exporter",
    "interop-be-metrics-report-generator",
    "interop-be-notifier",
    "interop-be-padigitale-report-generator",
    "interop-be-party-management",
    "interop-be-party-mock-registry",
    "interop-be-party-process",
    "interop-be-party-registry-proxy",
    "interop-be-privacy-notices-updater",
    "interop-be-purpose-management",
    "interop-be-purpose-process",
    "interop-be-tenant-management",
    "interop-be-tenant-process",
    "interop-be-tenants-cert-attr-updater",
    "interop-be-token-details-persister",
    "interop-frontend"
  ]
}

# TODO: refactor the for_each -> count
resource "aws_ecr_repository" "app" {
  for_each = { for repo in local.repository_name : repo => repo }

  image_tag_mutability = local.is_prod ? "IMMUTABLE" : "MUTABLE"
  name                 = each.key
}

resource "aws_ecr_lifecycle_policy" "app" {
  for_each = { for repo in aws_ecr_repository.app : repo.name => repo if local.is_prod == false }

  repository = each.value.name
  policy     = <<EOF
  {
    "rules": [
      {
        "rulePriority": 1,
        "description": "Delete untagged images",
        "selection": {
          "tagStatus": "untagged",
          "countType": "sinceImagePushed",
          "countUnit": "days",
          "countNumber": 1
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  }
  EOF
}
