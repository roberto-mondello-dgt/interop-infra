locals {
  # workaround to allow both 'dev' and 'dev-refactor'
  k8s_namespace_irsa = var.env == "dev" ? "dev*" : var.env
}
