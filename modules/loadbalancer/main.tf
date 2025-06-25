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

  access_logs {
    bucket  = var.bucket_name
    prefix  = var.prefix
    enabled = var.logs_enabled
  }

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

resource "aws_lb_listener" "http" {
  count             = var.enable_http ? 1 : 0
  load_balancer_arn = aws_lb.test.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example.arn
  }
}
resource "aws_lb_listener" "https" {
  count             = var.enable_https ? 1 : 0
  load_balancer_arn = aws_lb.test.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example.arn
  }
}

variable "enable_http" {
  description = "Enable HTTP listener"
  type        = bool  
}
variable "enable_https" {
  description = "Enable HTTPS listener"
  type        = bool    
}
variable "certificate_arn" {
  description = "ARN of the SSL certificate for HTTPS listener"
  type        = string  
}