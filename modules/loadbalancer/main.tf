locals {
  name = "${var.environment}-${var.project_name}-${var.lb_name}"
}
resource "aws_lb" "test" {
  name               = local.name
  internal           = var.choose_internal_external
  load_balancer_type = var.load_balancer_type
  security_groups    = var.security_groups
  subnets            = var.subnets
  enable_zonal_shift = var.enable_zonal_shift
  enable_deletion_protection = var.enable_deletion_protection

#   access_logs {
#     bucket  = var.bucket_name
#     prefix  = var.prefix
#     enabled = var.logs_enabled
#   }

  tags = merge(
    var.common_tags,
    {
      Name = local.name
    }
  )
}

resource "aws_route53_record" "www" {
  zone_id = var.zone_id
  name    = var.alb_record_name
  type    = "A"

  alias {
    name                   = aws_lb.test.dns_name
    zone_id                = aws_lb.test.zone_id
    evaluate_target_health = true
  }
}

