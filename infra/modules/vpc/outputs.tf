output "private_subnet_ids" {
  value = module.vpc.private_subnets
}

output "public_subnet_ids" {
  value = module.vpc.public_subnets
}

output "intra_subnet_ids" {
  value = module.vpc.intra_subnets
}

output "elasticache_subnet_ids" {
  value = module.vpc.elasticache_subnets
}

output "database_subnet_ids" {
  value = module.vpc.database_subnets
}

output "default_vpc_security_group_id" {
  value = module.vpc.default_security_group_id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "database_subnet_group" {
  value = module.vpc.database_subnet_group
}

output "azs" {
  value = module.vpc.azs
}

output "vpc_secondary_cidr_blocks" {
  value = module.vpc.vpc_secondary_cidr_blocks
}

output "name" {
  value = module.vpc.name
}