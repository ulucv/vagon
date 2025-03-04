variable "vpc_cidr" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "vpc_flow_log_role_name" {
  type = string
}

variable "tag_eks" {
  type = string
}

variable "single_nat_type" {
  type = bool
}

variable "one_nat_gateway_per_az" {
  type = bool
}

variable "env" {
  type = string
}

variable "secondary_cidr_block" {
  type = list(string)
}

variable "region" {
  type= string
}

variable "domain_name" {
  type = string
}