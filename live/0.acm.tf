module "lb_acm" {
  source            = "../modules/acm"
  environment       = var.common_vars["environment"]
  project_name      = var.common_vars["application_name"]
  common_tags       = var.common_vars["common_tags"]
  domain_name       = var.lb_acm["domain_name"]
  validation_method = var.lb_acm["validation_method"]
  zone_id           = var.common_vars["zone_id"]
}

variable "lb_acm" {}

output "lb_acm_certificate_arn" {
  description = "The ARN of the ACM certificate"
  value       = module.lb_acm.certificate_arn
}

module "cf_acm" {
  source            = "../modules/acm"
  environment       = var.common_vars["environment"]
  project_name      = var.common_vars["application_name"]
  common_tags       = var.common_vars["common_tags"]
  zone_id           = var.common_vars["zone_id"]
  domain_name       = var.cf_acm["domain_name"]
  validation_method = var.cf_acm["validation_method"]
}

variable "cf_acm" {}

output "cf_acm_certificate_arn" {
  description = "The ARN of the ACM certificate"
  value       = module.cf_acm.certificate_arn
}
