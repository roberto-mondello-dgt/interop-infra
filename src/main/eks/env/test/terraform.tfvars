aws_region                         = "eu-central-1"
env                                = "test"
short_name                         = "interop"
vpc_id                             = "vpc-0713382934b0c8e66"
subnets_ids                        = ["subnet-0342cdf7bf026b921", "subnet-09ec4f618d407d142", "subnet-011c8c82c205925ec"]
k8s_version                        = "1.22"
vpc_cni_version                    = "v1.11.0-eksbuild.1"
coredns_version                    = "v1.8.7-eksbuild.1"
kube_proxy_version                 = "v1.22.6-eksbuild.1"
cluster_sec_group_name             = "interop-eks-test-ClusterSecurityGroup-16QIFW43ERPJ2"
fargate_system_profile_name        = "EKSFargateProfileSystem-QS2fU0O9zdCZ"
fargate_application_profile_name   = "EKSFargateProfileApplicatio-XvFSQiF2hcYy"
fargate_observability_profile_name = "EKSFargateProfileObservabil-1cJlsidGmmzz"
fargate_tools_profile_name         = "EKSFargateProfileTools-gazBKbCxXwJ3"

tags = {
  CreatedBy   = "Terraform"
  Environment = "test"
  Owner       = "PagoPA"
  Source      = "https://github.com/pagopa/interop-infra"
}
