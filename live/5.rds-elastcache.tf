data "aws_ssm_parameter" "rds_username" {
  name = "/example/rds/username"
}
data "aws_ssm_parameter" "rds_password" {
  name = "/example/rds/password"
}

# RDS
module "rds" {
  source                 = "../modules/rds"
  username               = data.aws_ssm_parameter.rds_username.value
  password               = data.aws_ssm_parameter.rds_password.value
  db_subnet_group_name   = module.vpc.db_subnet_group_name
  vpc_security_group_ids = [module.rds_sg.sg_id]
  environment            = var.common_vars["environment"]
  project                = var.common_vars["application_name"]
  common_tags            = var.common_vars["common_tags"]
  zone_id                = var.common_vars["zone_id"]
  allocated_storage      = var.rds["allocated_storage"]
  engine                 = var.rds["engine"]
  engine_version         = var.rds["engine_version"]
  instance_class         = var.rds["instance_class"]
  publicly_accessible    = var.rds["publicly_accessible"]
  skip_final_snapshot    = var.rds["skip_final_snapshot"]
  storage_type           = var.rds["storage_type"]
  rds_record_name        = var.rds["rds_record_name"]
  record_type            = var.rds["record_type"]
  ttl                    = var.rds["ttl"]
}

module "elasticache" {
  source                  = "../modules/elastic_cache"
  environment             = var.common_vars["environment"]
  project_name            = var.common_vars["application_name"]
  common_tags             = var.common_vars["common_tags"]
  zone_id                 = var.common_vars["zone_id"]
  security_group_ids      = [module.elastic_cache_sg.sg_id]
  subnet_ids              = module.vpc.db_subnet_ids
  engine                  = var.elasticache["engine"]
  major_engine_version    = var.elasticache["major_engine_version"]
  elasticache_record_name = var.elasticache["elasticache_record_name"]
  record_type             = var.elasticache["record_type"]
  ttl                     = var.elasticache["ttl"]
}


variable "rds" {}
variable "elasticache" {}




output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = module.rds.endpoint
}
output "elastic_cache_endpoint" {
  description = "The endpoint of the Elastic Cache cluster"
  value       = module.elasticache.endpoint
}