variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the EKS cluster will be deployed."
  type        = string
}

variable "private_subnet_ids" {
  description = "private subnets for the nodes"
  type        = list(string)
}

variable "intra_subnet_ids" {
  description = "intra subnets for the control plane"
  type        = list(string)
}

variable "tag_eks" {
  description = "tag for karpenter synced with the vpc"
  type        = string
}

variable "cluster_enabled_log_types" {
  description = "Cluster enabled log types"
  type = list(string)
}

variable "account" {
  description = "Account ID"
  type =string
}

variable "vpn_cidr_block" {
  type = list(string)
}