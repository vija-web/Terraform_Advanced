resource "aws_security_group_rule" "allow_ssh" {
  count = length(var.instances)
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"

  security_group_id        = local.sg_map[var.instances[count.index]]
  source_security_group_id = data.aws_ssm_parameter.Bastion_sg_id.value
}

resource "aws_security_group_rule" "allow_ssh_for_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"

  security_group_id        = data.aws_ssm_parameter.Bastion_sg_id.value
  cidr_blocks              = ["0.0.0.0/0"] 
}

resource "aws_security_group_rule" "catalogue_to_mongodb" {
  type                     = "ingress"
  from_port                = 27017
  to_port                  = 27017
  protocol                 = "tcp"

  security_group_id        = data.aws_ssm_parameter.Mongodb_sg_id.value
  source_security_group_id = data.aws_ssm_parameter.Catalogue_sg_id.value
}

resource "aws_security_group_rule" "allow_ssh_to_backend_alb" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"

  security_group_id        = data.aws_ssm_parameter.backend-alb_sg_id.value
  cidr_blocks              = ["0.0.0.0/0"] 
}

resource "aws_security_group_rule" "backend_alb_to_catalogue" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"

  security_group_id        = data.aws_ssm_parameter.Catalogue_sg_id.value  #catalogue
  source_security_group_id = data.aws_ssm_parameter.backend-alb_sg_id.value #backend_alb
}

resource "aws_security_group_rule" "Frontend_to_backend-alb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"

  security_group_id        = data.aws_ssm_parameter.backend-alb_sg_id.value
  source_security_group_id = data.aws_ssm_parameter.Frontend_sg_id.value
}

resource "aws_security_group_rule" "Frontend-alb_to_Frontend" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"

  security_group_id        = data.aws_ssm_parameter.Frontend_sg_id.value
  source_security_group_id = data.aws_ssm_parameter.frontend-alb_sg_id.value 
}

resource "aws_security_group_rule" "allusers_to_frontend_alb" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"

  security_group_id        = data.aws_ssm_parameter.frontend-alb_sg_id.value
  cidr_blocks              = ["0.0.0.0/0"] 
}

resource "aws_security_group_rule" "user_to_mongodb" {
  type                     = "ingress"
  from_port                = 27017
  to_port                  = 27017
  protocol                 = "tcp"

  security_group_id        = data.aws_ssm_parameter.Mongodb_sg_id.value
  source_security_group_id = data.aws_ssm_parameter.User_sg_id.value
}

resource "aws_security_group_rule" "user_to_redis" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"

  security_group_id        = data.aws_ssm_parameter.Redis_sg_id.value
  source_security_group_id = data.aws_ssm_parameter.User_sg_id.value
}

resource "aws_security_group_rule" "cart_to_redis" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"

  security_group_id        = data.aws_ssm_parameter.Redis_sg_id.value
  source_security_group_id = data.aws_ssm_parameter.Cart_sg_id.value
}

resource "aws_security_group_rule" "shipping_to_mysql" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"

  security_group_id        = data.aws_ssm_parameter.Mysql_sg_id.value
  source_security_group_id = data.aws_ssm_parameter.Shipping_sg_id.value
}

resource "aws_security_group_rule" "payment_to_rabbitmq" {
  type                     = "ingress"
  from_port                = 5672
  to_port                  = 5672
  protocol                 = "tcp"

  security_group_id        = data.aws_ssm_parameter.Rabbitmq_sg_id.value
  source_security_group_id = data.aws_ssm_parameter.Payment_sg_id.value
}

resource "aws_security_group_rule" "catalogue_to_cart" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"

  security_group_id        = data.aws_ssm_parameter.Catalogue_sg_id.value
  source_security_group_id = data.aws_ssm_parameter.Cart_sg_id.value
}

resource "aws_security_group_rule" "shipping_to_cart" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"

  security_group_id        = data.aws_ssm_parameter.Cart_sg_id.value
  source_security_group_id = data.aws_ssm_parameter.Shipping_sg_id.value
}

resource "aws_security_group_rule" "payment_to_cart" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"

  security_group_id        = data.aws_ssm_parameter.Cart_sg_id.value
  source_security_group_id = data.aws_ssm_parameter.Payment_sg_id.value
}

resource "aws_security_group_rule" "payment_to_user" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"

  security_group_id        = data.aws_ssm_parameter.User_sg_id.value
  source_security_group_id = data.aws_ssm_parameter.Payment_sg_id.value
}