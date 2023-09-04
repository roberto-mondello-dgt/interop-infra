# TODO: make time periods configurable
data "template_file" "monitoring_dashboard" {
  template = file("${path.module}/k8s_deployment_dashboard.tpl.json")

  vars = {
    Region                   = data.aws_region.current.name
    ClusterName              = var.eks_cluster_name
    Namespace                = var.k8s_namespace
    Service                  = var.k8s_deployment_name
    ServiceType              = "deployment"
    NumberOfDigitsMultiplier = pow(10, var.number_of_digits)
  }
}

resource "aws_cloudwatch_dashboard" "k8s_deployment" {
  dashboard_name = format("k8s-%s-%s", var.k8s_deployment_name, var.env)
  dashboard_body = data.template_file.monitoring_dashboard.rendered
}
