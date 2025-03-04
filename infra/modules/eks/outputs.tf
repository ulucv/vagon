output "cluster_id" {
  value = module.eks.cluster_id
}

output "cluster_version" {
  value = module.eks.cluster_version
}

output "node_security_group_id" {
  value = module.eks.node_security_group_id
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}