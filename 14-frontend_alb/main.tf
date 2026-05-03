
# Application Load Balancer
resource "aws_lb" "main_alb" {
  name               = "frontend-alb"
  internal           = false
  load_balancer_type = "application"

  # Public subnets in us-east-1a and us-east-1b
  subnets = [
    data.aws_ssm_parameter.public_subnet_ids[0].value,
    data.aws_ssm_parameter.public_subnet_ids[1].value
  ]

  security_groups = [
    data.aws_ssm_parameter.frontend_alb_sg_id.value
  ]

  tags = {
    Name = "frontend-alb"
  }
}

resource "aws_route53_record" "alb_route_creation" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "frontend-alb-${var.project}-${var.environment}"
  type    = "A"

  alias {
    name                   = aws_lb.main_alb.dns_name
    zone_id                = aws_lb.main_alb.zone_id
    evaluate_target_health = true
  }
}

# HTTP Listener
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.main_alb.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-Res-PQ-2025-09"

  certificate_arn   = data.aws_ssm_parameter.roboshop-certificate.value

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Invalid backend API path" # other than this /api/*
      status_code  = "404"
    }
  }
}


# Listener Rule for /api/*
resource "aws_lb_listener_rule" "catalogue_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = data.application_tg_arn.value
  }
  
  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}



