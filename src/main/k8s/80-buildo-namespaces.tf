resource "kubernetes_namespace_v1" "dev_refactor" {
  count = var.env == "dev" ? 1 : 0

  metadata {
    name = "dev-refactor"
  }
}
