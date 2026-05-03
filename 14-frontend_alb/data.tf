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

data "aws_ssm_parameter" "frontend_alb_sg_id" {
  name = "${local.common}-frontend-alb-sg"
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

data "aws_ssm_parameter" "application_tg_arn" {
  name = "frontend-tg-arn"
}

data "aws_ssm_parameter" "roboshop-certificate" {
  name = "${var.project}-${var.env}-certificate_arn"
}