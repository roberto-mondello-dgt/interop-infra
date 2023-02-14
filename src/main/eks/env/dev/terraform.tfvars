aws_region                         = "eu-central-1"
env                                = "dev"
short_name                         = "interop"
vpc_id                             = "vpc-07716b81f761d4009"
subnets_ids                        = ["subnet-0724dc3d03e7c34d6", "subnet-00c2fd51d3dad5f30", "subnet-0067deeb544f58d99"]
k8s_version                        = "1.22"
vpc_cni_version                    = "v1.11.0-eksbuild.1"
coredns_version                    = "v1.8.7-eksbuild.1"
kube_proxy_version                 = "v1.22.6-eksbuild.1"
cluster_sec_group_name             = "interop-eks-dev-ClusterSecurityGroup-1WCBURXQDAHHN"
fargate_system_profile_name        = "EKSFargateProfileSystem-GTigYv4p5CgY"
fargate_application_profile_name   = "EKSFargateProfileApplicatio-UohA0LUXvAOP"
fargate_observability_profile_name = "EKSFargateProfileObservabil-djlff8sAMua3"

tags = {
  CreatedBy   = "Terraform"
  Environment = "dev"
  Owner       = "PagoPA"
  Source      = "https://github.com/pagopa/interop-infra"
}
