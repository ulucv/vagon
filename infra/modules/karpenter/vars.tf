variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "region" {
  description = "region"
  type        = string
}

variable "cluster_endpoint" {
  description = "cluster_endpoint"
  type        = string
}

variable "cluster_certificate_authority_data" {
  description = "cluster_certificate_authority_data"
  type        = string
}

variable "tag_eks" {
  description = "tag for karpenter synced with the vpc"
  type        = string
}

variable "account" {
  description = "account id for the env"
  type        = string
}

variable "capacity_type" {
  description = "Instance type for karpenter nodes"
  type        = string
}