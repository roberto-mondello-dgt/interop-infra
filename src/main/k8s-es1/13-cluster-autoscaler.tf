data "aws_iam_role" "cluster_autoscaler" {
  count = local.deploy_cluster_autoscaler ? 1 : 0

  name = var.cluster_autoscaler_irsa_name
}

resource "helm_release" "cluster_autoscaler" {
  count = local.deploy_cluster_autoscaler ? 1 : 0

  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  version    = var.cluster_autoscaler_chart_version
  namespace  = "kube-system"

  set {
    name  = "fullnameOverride"
    value = "cluster-autoscaler"
  }

  set {
    name  = "cloudProvider"
    value = "aws"
  }

  set {
    name  = "awsRegion"
    value = var.aws_region
  }

  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = data.aws_iam_role.cluster_autoscaler[0].arn
  }

  set {
    name  = "autoDiscovery.clusterName"
    value = data.aws_eks_cluster.this.name
  }

  set {
    name  = "replicaCount"
    value = var.env == "prod" ? 2 : 1
  }
}
