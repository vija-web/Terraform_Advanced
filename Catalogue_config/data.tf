data "aws_availability_zones" "available" {
  state = "available"
  region = var.region_name
}

data "aws_ssm_parameter" "public_subnet_id_useast1a" {
  name = "${local.common}-public_subnet-us-east-1a"
}

data "aws_ssm_parameter" "public_subnet_id_useast1b" {
  name = "${local.common}-public_subnet-us-east-1b"
}

data "aws_ssm_parameter" "application_subnet_ids" {
  count = 2
  name = "${local.common}-application_subnet-${var.zones[count.index]}"
}

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

data "aws_ssm_parameter" "bastion_sg_id" {
  name = "${local.common}-Bastion-sg"
}

data "aws_ssm_parameter" "backend_alb_sg_id" {
  name = "${local.common}-backend-alb-sg"
}

data "aws_ssm_parameter" "roboshop_vpc_id" {
  name = "${var.project}-vpc_id"
}
