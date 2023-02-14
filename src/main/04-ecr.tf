locals {
  is_prod = var.env == "prod"
  is_test = var.env == "test"
  repository_name = [
    "interop-be-agreement-management",
    "interop-be-agreement-process",
    "interop-be-api-gateway",
    "interop-be-attribute-registry-management",
    "interop-be-attributes-loader",
    "interop-be-authorization-management",
    "interop-be-authorization-process",
    "interop-be-authorization-server",
    "interop-be-backend-for-frontend",
    "interop-be-catalog-management",
    "interop-be-catalog-process",
    "interop-be-notifier",
    "interop-be-party-mock-registry",
    "interop-be-party-registry-proxy",
    "interop-be-purpose-management",
    "interop-be-purpose-process",
    "interop-frontend"
  ]
}

resource "aws_ecr_repository" "app" {
  for_each             = { for repo in local.repository_name : repo => repo if local.is_test == false }
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
