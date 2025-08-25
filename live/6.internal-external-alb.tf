module "internal-alb" {
  source                     = "../modules/elb"
  environment                = var.common_vars["environment"]
  project                    = var.common_vars["application_name"]
  common_tags                = var.common_vars["common_tags"]
  security_groups            = [module.internal_alb_sg.sg_id]
  subnets                    = module.vpc.private_subnet_ids
  vpc_id                     = module.vpc.vpc_id
  lb_name                    = var.internal_alb["lb_name"]
  enable_deletion_protection = var.internal_alb["enable_deletion_protection"]
  choose_internal_external   = var.internal_alb["choose_internal_external"]
  load_balancer_type         = var.internal_alb["load_balancer_type"]
  enable_zonal_shift         = var.internal_alb["enable_zonal_shift"]
  tg_port                    = var.internal_alb["tg_port"]
  health_check_path          = var.internal_alb["health_check_path"]
  enable_http                = var.internal_alb["enable_http"]
  enable_https               = var.internal_alb["enable_https"]
  zone_id                    = var.common_vars["zone_id"]
  record_name                = var.internal_alb["record_name"]
}



module "external-alb" {
  depends_on                 = [module.lb_acm]
  source                     = "../modules/elb"
  environment                = var.common_vars["environment"]
  project                    = var.common_vars["application_name"]
  common_tags                = var.common_vars["common_tags"]
  security_groups            = [module.external_alb_sg.sg_id]
  subnets                    = module.vpc.public_subnet_ids
  vpc_id                     = module.vpc.vpc_id
  lb_name                    = var.external_alb["lb_name"]
  enable_deletion_protection = var.external_alb["enable_deletion_protection"]
  choose_internal_external   = var.external_alb["choose_internal_external"]
  load_balancer_type         = var.external_alb["load_balancer_type"]
  enable_zonal_shift         = var.external_alb["enable_zonal_shift"]
  tg_port                    = var.external_alb["tg_port"]
  health_check_path          = var.external_alb["health_check_path"]
  enable_http                = var.external_alb["enable_http"]
  enable_https               = var.external_alb["enable_https"]
  certificate_arn            = module.lb_acm.certificate_arn
  zone_id                    = var.common_vars["zone_id"]
  record_name                = var.external_alb["record_name"]
}

variable "internal_alb" {}

variable "external_alb" {}
