data "aws_ssm_parameter" "Catalogue_sg_id" {
  name = "${local.common}-Catalogue-sg"
}

data "aws_ssm_parameter" "Cart_sg_id" {
  name = "${local.common}-Cart-sg"
}

data "aws_ssm_parameter" "Shipping_sg_id" {
  name = "${local.common}-Shipping-sg"
}

data "aws_ssm_parameter" "Payment_sg_id" {
  name = "${local.common}-Payment-sg"
}

data "aws_ssm_parameter" "User_sg_id" {
  name = "${local.common}-User-sg"
}

data "aws_ssm_parameter" "Bastion_sg_id" {
  name = "${local.common}-Bastion-sg"
}

data "aws_ssm_parameter" "backend-alb_sg_id" {
  name = "${local.common}-backend-alb-sg"
}

data "aws_ssm_parameter" "frontend-alb_sg_id" {
  name = "${local.common}-frontend-alb-sg"
}

data "aws_ssm_parameter" "Mongodb_sg_id" {
  name = "${local.common}-Mongodb-sg"
}

data "aws_ssm_parameter" "Redis_sg_id" {
  name = "${local.common}-Redis-sg"
}

data "aws_ssm_parameter" "Rabbitmq_sg_id" {
  name = "${local.common}-RabbitMQ-sg"
}

data "aws_ssm_parameter" "Mysql_sg_id" {
  name = "${local.common}-Mysql-sg"
}

data "aws_ssm_parameter" "Frontend_sg_id" {
  name = "${local.common}-Frontend-sg"
}

data "aws_availability_zones" "available" {
  state = "available"
  region = var.region_name
}

data "aws_ssm_parameter" "roboshop_vpc_id" {
  name = "${var.project}-vpc_id"
}