variable "domain_name" {
  description = "Route 53 domain name"
  type        = string
}
variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}
variable "region" {
  description = "AWS region"
  type        = string
}
variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28"
}
variable "addons" {
  description = "Kubernetes addons"
  type        = any
  default = {
    enable_external_dns                 = false
    enable_aws_load_balancer_controller = true
    enable_aws_argocd_ingress           = true
    enable_keda                         = true
  }
}
# Addons Git
variable "gitops_addons_org" {
  description = "Git repository org/user contains for addons"
  type        = string
  default     = "https://github.com/gitops-bridge-dev"
}
variable "gitops_addons_repo" {
  description = "Git repository contains for addons"
  type        = string
  default     = "gitops-bridge-argocd-control-plane-template"
}
variable "gitops_addons_revision" {
  description = "Git repository revision/branch/ref for addons"
  type        = string
  default     = "main"
}
variable "gitops_addons_basepath" {
  description = "Git repository base path for addons"
  type        = string
  default     = ""
}
variable "gitops_addons_path" {
  description = "Git repository path for addons"
  type        = string
  default     = "bootstrap/control-plane/addons"
}

variable "cluster_endpoint" {
  description = "EKS Cluster endpoint"
  type        = string
}
variable "cluster_certificate_authority_data" {
  description = "EKS Cluster CA data"
  type        = string
}
variable "cluster_name" {
  description = "Cluster Name"
  type        = string
}
variable "vpc_id" {
  description = "VPC ID for"
  type        = string
}
variable "cluster_version" {
  description = "Cluster version"  
  type        = string
}
variable "oidc_provider_arn" {
  description = "OIDC Provider ARN"  
  type        = string
}
variable "env" {
  description = "Environment"  
  type        = string
}
