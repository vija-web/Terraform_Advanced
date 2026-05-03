data "aws_availability_zones" "available" {
  state = "available"
  region = var.region_name
}

data "aws_ssm_parameter" "application_subnet_ids" {
  count = 2
  name = "${local.common}-application_subnet-${var.zones[count.index]}"
}

data "aws_ssm_parameter" "public_subnet_ids" {
  count = 2
  name = "${local.common}-public_subnet-${var.zones[count.index]}"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  count = 2
  name = "${local.common}-private_subnet-${var.zones[count.index]}"
}

data "aws_ssm_parameter" "catalogue_sg_id" {
  name = "${local.common}-Catalogue-sg"
}

data "aws_ssm_parameter" "cart_sg_id" {
  name = "${local.common}-Cart-sg"
}

data "aws_ssm_parameter" "shipping_sg_id" {
  name = "${local.common}-Shipping-sg"
}

data "aws_ssm_parameter" "payment_sg_id" {
  name = "${local.common}-Payment-sg"
}

data "aws_ssm_parameter" "user_sg_id" {
  name = "${local.common}-User-sg"
}

data "aws_ssm_parameter" "bastion_sg_id" {
  name = "${local.common}-Bastion-sg"
}

data "aws_ssm_parameter" "backend_alb_sg_id" {
  name = "${local.common}-backend-alb-sg"
}

data "aws_ssm_parameter" "roboshop_vpc_id" {
  name = "${var.project}-vpc_id"
}

data "aws_route53_zone" "selected" {
  name         = "vijayaws.fun"
}

data "aws_ssm_parameter" "ami_password" {
  name = "ami_password"
}

data "aws_ssm_parameter" "catalogue_tg_arn" {
  name = "catalogue-tg-arn"
}

data "aws_ssm_parameter" "user_tg_arn" {
  name = "user-tg-arn"
}

data "aws_ssm_parameter" "cart_tg_arn" {
  name = "cart-tg-arn"
}

data "aws_ssm_parameter" "shipping_tg_arn" {
  name = "shipping-tg-arn"
}

data "aws_ssm_parameter" "payment_tg_arn" {
  name = "payment-tg-arn"
}