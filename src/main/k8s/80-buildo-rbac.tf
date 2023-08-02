resource "kubernetes_role_binding_v1" "buildo_devs" {
  count = var.env == "dev" ? 1 : 0

  metadata {
    name      = "buildo-devs"
    namespace = kubernetes_namespace_v1.dev_refactor[0].metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "admin"
  }

  subject {
    kind      = "Group"
    name      = "buildo-devs"
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_role_binding_v1" "buildo_gh_actions" {
  count = var.env == "dev" ? 1 : 0

  metadata {
    name      = "buildo-gh-actions"
    namespace = kubernetes_namespace_v1.dev_refactor[0].metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "admin"
  }

  subject {
    kind      = "Group"
    name      = "buildo-gh-actions"
    api_group = "rbac.authorization.k8s.io"
  }
}
