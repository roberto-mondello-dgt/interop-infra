output "cluster_arn" {
  description = "ARN of the EKS cluster"
  value       = module.eks.cluster_arn
}

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "api_server_endpoint" {
  description = "K8s API server endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_oidc_provider_url" {
  description = "URL of the cluster OIDC provider"
  value       = module.eks.cluster_oidc_issuer_url
}

output "cluster_oidc_provider_arn" {
  description = "ARN of the cluster OIDC provider"
  value       = module.eks.oidc_provider_arn
}
