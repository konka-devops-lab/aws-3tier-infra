output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

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

# output "bastion_sg_id" {
#   description = "The ID of the bastion security group"
#   value       = module.sg.bastion_sg_id
# }
# output "vpn_sg_id" {
#   description = "The ID of the VPN security group"
#   value       = module.sg.vpn_sg_id
# }
# output "rds_sg_id" {
#   description = "The ID of the RDS security group"
#   value       = module.sg.rds_sg_id
# }
# output "elastic_sg_id" {
#   description = "The ID of the Elastic security group"
#   value       = module.sg.elastic_sg_id
# }
# output "backend_sg_id" {
#   description = "The ID of the backend security group"
#   value       = module.sg.backend_sg_id
# }
# output "internal_alb_sg_id" {
#   description = "The ID of the internal ALB security group"
#   value       = module.sg.internal_alb_sg_id
# }
# output "external_alb_sg_id" {
#   description = "The ID of the external ALB security group"
#   value       = module.sg.external_alb_sg_id
# }
# output "frontend_sg_id" {
#   description = "The ID of the frontend security group"
#   value       = module.sg.frontend_sg_id
# }