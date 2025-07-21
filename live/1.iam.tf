module "backend_role" {
  source       = "../modules/iam"
  environment  = var.common_vars["environment"]
  project_name = var.common_vars["application_name"]
  common_tags  = var.common_vars["common_tags"]
  role_name    = var.backend_role["role_name"]
  policy_name  = var.backend_role["policy_name"]
  policy_file  = "${path.module}/../environments/${var.common_vars["environment"]}/policies/backend-policy.json"
}
module "frontend_role" {
  source       = "../modules/iam"
  environment  = var.common_vars["environment"]
  project_name = var.common_vars["application_name"]
  common_tags  = var.common_vars["common_tags"]
  role_name    = var.frontend_role["role_name"]
  policy_name  = var.frontend_role["policy_name"]
  policy_file  = "${path.module}/../environments/${var.common_vars["environment"]}/policies/frontend-policy.json"
}

variable "backend_role" {}
variable "frontend_role" {}


output "backend_role_id" {
  description = "The ID of the backend IAM role"
  value       = module.backend_role.role_id
}
output "backend_role_arn" {
  description = "The ARN of the backend IAM role"
  value       = module.backend_role.role_arn
}
output "backend_instance_profile_id" {
  description = "The ID of the backend IAM instance profile"
  value       = module.backend_role.instance_profile_id
}
output "backend_instance_profile_arn" {
  description = "The ARN of the backend IAM instance profile"
  value       = module.backend_role.instance_profile_arn
}
output "frontend_role_id" {
  description = "The ID of the frontend IAM role"
  value       = module.frontend_role.role_id
}
output "frontend_role_arn" {
  description = "The ARN of the frontend IAM role"
  value       = module.frontend_role.role_arn
}

output "frontend_instance_profile_arn" {
  description = "The ARN of the backend IAM instance profile"
  value       = module.frontend_role.instance_profile_arn
}
output "frontend_instance_role_id" {
  description = "The ID of the frontend IAM role"
  value       = module.frontend_role.instance_profile_id
}
