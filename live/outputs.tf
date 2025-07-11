output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}
# output "parameterstore_arns" {
#   description = "The ARNs of the created SSM parameters"
#   value       = module.paramterstore.arns
# }

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}
output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}
output "db_subnet_ids" {
  description = "List of database subnet IDs"
  value       = module.vpc.db_subnet_ids
}
output "db_subnet_group_name" {
  description = "The name of the DB subnet group"
  value       = module.vpc.db_subnet_group_name
}

output "bastion_sg_id" {
  description = "The ID of the bastion security group"
  value       = module.bastion_sg.sg_id
}
output "vpn_sg_id" {
  description = "The ID of the VPN security group"
  value       = module.vpn_sg.sg_id
}
output "rds_sg_id" {
  description = "The ID of the RDS security group"
  value       = module.rds_sg.sg_id
}
output "elastic_cache_sg_id" {
  description = "The ID of the Elastic security group"
  value       = module.elastic_cache_sg.sg_id
}
# output "backend_sg_id" {
#   description = "The ID of the backend security group"
#   value       = module.backend_sg.sg_id
# }
# output "internal_alb_sg_id" {
#   description = "The ID of the internal ALB security group"
#   value       = module.internal_alb_sg.sg_id
# }
# output "external_alb_sg_id" {
#   description = "The ID of the external ALB security group"
#   value       = module.external_alb_sg.sg_id
# }
# output "frontend_sg_id" {
#   description = "The ID of the frontend security group"
#   value       = module.frontend_sg.sg_id
# }

output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = module.rds.endpoint
}
output "elastic_cache_endpoint" {
  description = "The endpoint of the Elastic Cache cluster"
  value       = module.elasticache.endpoint
}
# output "acm_certificate_arn" {
#   description = "The ARN of the ACM certificate"
#   value       = module.lb_acm.certificate_arn
# }
# output "backend_role_id" {
#   description = "The ID of the backend IAM role"
#   value       = module.backend_role.role_id
# }
# output "backend_role_arn" {
#   description = "The ARN of the backend IAM role"
#   value       = module.backend_role.arn
# }
# output "backend_role_name" {
#   description = "The name of the backend IAM role"
#   value       = module.backend_role.name
# }
# output "frontend_role_id" {
#   description = "The ID of the frontend IAM role"
#   value       = module.frontend_role.role_id
# }
# output "frontend_role_arn" {
#   description = "The ARN of the frontend IAM role"
#   value       = module.frontend_role.arn
# }
# output "frontend_role_name" {
#   description = "The name of the frontend IAM role"
#   value       = module.frontend_role.name
# }