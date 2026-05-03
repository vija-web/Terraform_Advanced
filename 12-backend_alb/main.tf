
# Application Load Balancer
resource "aws_lb" "main_alb" {
  name               = "backend-alb"
  internal           = false
  load_balancer_type = "application"

  # Public subnets in us-east-1a and us-east-1b
  subnets = [
    data.aws_ssm_parameter.private_subnet_ids[0].value,
    data.aws_ssm_parameter.private_subnet_ids[1].value
  ]

  security_groups = [
    data.aws_ssm_parameter.backend_alb_sg_id.value
  ]

  tags = {
    Name = "backend-alb"
  }
}

resource "aws_route53_record" "alb_route_creation" {
  count = length(var.microservices)
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.microservices[count.index]}.backend-alb-${var.project}-${var.environment}"
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
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Invalid backend API path" # other than this /products
      status_code  = "404"
    }
  }
}


# Listener Rule
resource "aws_lb_listener_rule" "catalogue_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = data.catalogue_tg_arn.value
  }
  
  condition {
    host_header {
      values = [
        "catalogue.backend-alb-${var.project}-${var.environment}.${var.domain_name}"
      ]
    }
  }
}

resource "aws_lb_listener_rule" "catalogue_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = data.user_tg_arn.value
  }
  
  condition {
    host_header {
      values = [
        "user.backend-alb-${var.project}-${var.environment}.${var.domain_name}"
      ]
    }
  }
}

resource "aws_lb_listener_rule" "catalogue_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 3

  action {
    type             = "forward"
    target_group_arn = data.cart_tg_arn.value
  }
  
  condition {
    host_header {
      values = [
        "cart.backend-alb-${var.project}-${var.environment}.${var.domain_name}"
      ]
    }
  }
}

resource "aws_lb_listener_rule" "catalogue_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 4

  action {
    type             = "forward"
    target_group_arn = data.shipping_tg_arn.value
  }
  
  condition {
    host_header {
      values = [
        "shipping.backend-alb-${var.project}-${var.environment}.${var.domain_name}"
      ]
    }
  }
}

resource "aws_lb_listener_rule" "catalogue_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 5

  action {
    type             = "forward"
    target_group_arn = data.payment_tg_arn.value
  }
  
  condition {
    host_header {
      values = [
        "payment.backend-alb-${var.project}-${var.environment}.${var.domain_name}"
      ]
    }
  }
}



