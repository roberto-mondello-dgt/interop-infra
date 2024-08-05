data "aws_iam_role" "aws_load_balancer_controller" {
  name = var.aws_load_balancer_controller_role_name
}

resource "kubernetes_service_account_v1" "aws_load_balancer_controller" {
  metadata {
    namespace = "kube-system"
    name      = "aws-load-balancer-controller"

    annotations = {
      "eks.amazonaws.com/role-arn" = data.aws_iam_role.aws_load_balancer_controller.arn
    }

    labels = {
      "app.kubernetes.io/name" = "aws-load-balancer-controller"
    }
  }
}

resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.4.8"
  namespace  = "kube-system"

  set {
    name  = "region"
    value = var.aws_region
  }

  set {
    name  = "vpcId"
    value = data.aws_eks_cluster.this.vpc_config[0].vpc_id
  }


  set {
    name  = "clusterName"
    value = data.aws_eks_cluster.this.name
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account_v1.aws_load_balancer_controller.metadata[0].name
  }
}
