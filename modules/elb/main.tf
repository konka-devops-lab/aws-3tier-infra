locals {
  name = "${var.environment}-${var.project}"
  s3_bucket_name = "${local.name}-lb-logs"
}
resource "aws_s3_bucket" "example" {
  bucket = local.s3_bucket_name

  tags = merge(
    {
      Name = local.name
    },
    var.common_tags
  )
}
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_policy" "alb_log_delivery" {
  bucket = aws_s3_bucket.example.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AWSALBLoggingPolicy"
        Effect = "Allow"
        Principal = {
          Service = "logdelivery.elasticloadbalancing.amazonaws.com"
        }
        Action = "s3:PutObject"
        Resource = "${aws_s3_bucket.example.arn}/${local.name}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

resource "aws_lb" "test" {
  name               = local.name
  internal           = var.choose_internal_external
  load_balancer_type = var.load_balancer_type
  security_groups    = var.security_groups
  subnets            = var.subnets

  enable_deletion_protection = var.enable_deletion_protection

  access_logs {
    bucket  = aws_s3_bucket.example.id
    prefix  = local.name
    enabled = true
  }

  tags = merge(
    {
      Name = local.name
    },
    var.common_tags
  )
}

resource "aws_lb_target_group" "example" {    
  name     = "${var.environment}-${var.project}-tg"
  port     = var.tg_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = var.health_check_path
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(
    {
      Name = local.name
    },
    var.common_tags
  )
}
