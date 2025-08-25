
common_vars = {
  environment      = "development"
  application_name = "carvo"
  region = "us-east-1"
  common_tags = {
    Project     = "carvo"
    Environment = "development"
    terraform   = "true"
    Owner       = "konka"
    Monitoring  = "true"
  }
  zone_id = "Z011675617HENPLWZ1EJC"
}
vpc = {
  vpc_cidr_block             = "10.1.0.0/16"
  availability_zone          = ["us-east-1a", "us-east-1b"]
  public_subnet_cidr_blocks  = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnet_cidr_blocks = ["10.1.11.0/24", "10.1.12.0/24"]
  db_subnet_cidr_blocks      = ["10.1.21.0/24", "10.1.22.0/24"]
  enable_nat_gateway         = true
  enable_vpc_flow_logs_cw    = false
}
# parameter_store = {
#   parameters = {
#     DB_HOST = "dev-rds.konkas.tech"
#     DB_NAME = "crud_app"
#     REDIS_HOST = "dev-elasticache.konkas.tech"
#   }
# }

sg = {
  bastion_sg_name        = "Bastion"
  bastion_sg_description = "Bastion SG"

  vpn_sg_name        = "VPN"
  vpn_sg_description = "VPN SG"

  rds_sg_name        = "RDS"
  rds_sg_description = "RDS SG"

  elastic_cache_sg_name        = "Elastic_Cache"
  elastic_cache_sg_description = "Elastic_Cache SG"

  backend_sg_name        = "Backend"
  backend_sg_description = "Backend SG"

  internal_alb_sg_name        = "Internal-ALB"
  internal_alb_sg_description = "Internal SG"

  frontend_sg_name        = "Frontend"
  frontend_sg_description = "Frontend SG"

  external_alb_sg_name        = "External-ALB"
  external_alb_sg_description = "External_ALB SG"

  prometheus_sg_name = "Prometheus"
  prometheus_sg_description = "Prometheus SG"
}

bastion_ec2 = {
  instance_name                  = "bastion"
  instance_type                  = "t3.micro"
  key_name                       = "siva"
  monitoring                     = false
  use_null_resource_for_userdata = true
  remote_exec_user               = "ec2-user"
  iam_instance_profile           = ""
}

# vpn_ec2 = {
#   instance_name                  = "vpn"
#   instance_type                  = "t3a.small"
#   key_name                       = "siva"
#   monitoring                     = false
#   use_null_resource_for_userdata = false
# }

rds = {
  allocated_storage   = "20"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  publicly_accessible = false
  skip_final_snapshot = true
  storage_type        = "gp3"
  zone_id             = "Z011675617HENPLWZ1EJC"
  rds_record_name     = "dev-rds"
  record_type         = "CNAME"
  ttl                 = "60"
}

elasticache = {
  engine                  = "valkey"
  major_engine_version    = "8"
  zone_id                 = "Z011675617HENPLWZ1EJC"
  elasticache_record_name = "dev-elasticache"
  record_type             = "CNAME"
  ttl                     = "60"
}

lb_acm = {
  domain_name       = "dev-frontend.konkas.tech"
  validation_method = "DNS"
}

cf_acm = {
  domain_name       = "dev-carvo.konkas.tech"
  validation_method = "DNS"
}

internal_alb = {
  lb_name                    = "backned"
  enable_deletion_protection = false
  choose_internal_external   = true
  enable_zonal_shift         = false
  load_balancer_type         = "application"
  tg_port                    = 8080
  health_check_path          = "/health"
  enable_http                = true
  enable_https               = false
  record_name                = "dev-backend.konkas.tech"
}
external_alb = {
  lb_name                    = "frontend"
  enable_deletion_protection = false
  choose_internal_external   = false
  enable_zonal_shift         = false
  load_balancer_type         = "application"
  tg_port                    = 80
  health_check_path          = "/"
  enable_http                = false
  enable_https               = true
  record_name                = "dev-frontend.konkas.tech"
}

backend_role = {
  role_name   = "backendsecretsparameterstore"
  policy_name = "backendsecretsparameterstorePolicy"
}

frontend_role = {
  role_name   = "frontendngincconf"
  policy_name = "frontendngincconfpolicy"
}

prometheus_role = {
  role_name   = "prometheusreadonly"
  policy_name = "prometheusreadonlypolicy"
}

backend_asg = {
  monitoring_enable = false
  min_size          = 1
  max_size          = 1
  desired_capacity  = 1
  instance_name     = "backend"
  target_value      = 20
}

frontend_asg = {
  monitoring_enable = false
  min_size          = 1
  max_size          = 1
  desired_capacity  = 1
  instance_name     = "frontend"
  target_value      = 20
}

cdn = {
  domain_name            ="dev-frontend.konkas.tech"
  aliases              = ["dev-carvo.konkas.tech"]
  record_name          = "dev-carvo.konkas.tech"
}

prometheus_ec2 = {
  instance_name                  = "prometheus"
  instance_type                  = "t3a.medium"
  key_name                       = "siva"
  monitoring                     = false
  use_null_resource_for_userdata = true
  remote_exec_user               = "ec2-user"
}