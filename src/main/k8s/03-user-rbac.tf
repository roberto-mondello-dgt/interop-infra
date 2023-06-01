resource "kubernetes_cluster_role_v1" "iac_readonly" {
  metadata {
    name = "iac-readony-cluster-role"
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding_v1" "iac_readonly" {
  metadata {
    name = "iac-readonly"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "Group"
    name      = "iac-readonly-group"
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_role" "port_forward" {
  count = var.env != "prod" ? 1 : 0

  metadata {
    name      = "port-forward-role"
    namespace = kubernetes_namespace_v1.env.metadata[0].name
  }

  rule {
    api_groups = [""]
    resources  = ["pods/portforward"]
    verbs      = ["create"]
  }
}

resource "kubernetes_role_binding_v1" "readonly_group_view" {
  metadata {
    name      = "readonly-group-view"
    namespace = kubernetes_namespace_v1.env.metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view"
  }

  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = "readonly-group"
  }
}

resource "kubernetes_role_binding_v1" "readonly_group_port_forward" {
  count = var.env != "prod" ? 1 : 0

  metadata {
    name      = "readonly-group-port-forward"
    namespace = kubernetes_namespace_v1.env.metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.port_forward[0].metadata[0].name
  }

  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = "readonly-group"
  }
}
