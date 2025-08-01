module "cdn-3-tier" {
  source              = "../modules/cloudfront"
  environment         = var.common_vars["environment"]
  application_name    = var.common_vars["application_name"]
  common_tags         = var.common_vars["common_tags"]
  aliases             = var.cdn["aliases"]
  domain_name         = var.cdn["domain_name"]
  acm_certificate_arn = module.cf_acm.certificate_arn
  zone_id             = var.common_vars["zone_id"]
  record_name         = var.cdn["record_name"]
}


variable "cdn" {

}

output "cdn_id" {
  value = module.cdn-3-tier.cdn_id
}
