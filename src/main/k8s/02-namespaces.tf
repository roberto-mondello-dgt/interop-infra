resource "kubernetes_namespace_v1" "env" {
  metadata {
    name = var.env
  }
}

resource "kubernetes_namespace_v1" "aws_observability" {
  metadata {
    name = "aws-observability"

    labels = {
      aws-observability = "enabled"
    }
  }
}

resource "kubernetes_namespace_v1" "dev_refactor" {
  count = var.env == "dev" ? 1 : 0

  metadata {
    name = "dev-refactor"
  }
}
