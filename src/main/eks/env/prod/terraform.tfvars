aws_region                         = "eu-central-1"
env                                = "prod"
short_name                         = "interop"
vpc_id                             = "vpc-0c13c03f09872cc1f"
subnets_ids                        = ["subnet-02114a2f5cc5e897b", "subnet-0f9d4a21571501aeb", "subnet-04a8ee446809c85db"]
k8s_version                        = "1.22"
vpc_cni_version                    = "v1.11.0-eksbuild.1"
coredns_version                    = "v1.8.7-eksbuild.1"
kube_proxy_version                 = "v1.22.6-eksbuild.1"
cluster_sec_group_name             = "interop-eks-prod-ClusterSecurityGroup-1H0D9ZVLDUHVQ"
fargate_system_profile_name        = "EKSFargateProfileSystem-2RB12zIlpchE"
fargate_application_profile_name   = "EKSFargateProfileApplicatio-FkDoyIhs6jYQ"
fargate_observability_profile_name = "EKSFargateProfileObservabil-QpaGeucb7cnx"
fargate_tools_profile_name         = "EKSFargateProfileTools-zBlgiS6GldsF"

tags = {
  CreatedBy   = "Terraform"
  Environment = "prod"
  Owner       = "PagoPA"
  Source      = "https://github.com/pagopa/interop-infra"
}
