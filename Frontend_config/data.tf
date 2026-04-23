data "aws_availability_zones" "available" {
  state = "available"
  region = var.region_name
}

data "aws_ssm_parameter" "public_subnet_ids" {
  count = 2
  name = "${local.common}-public_subnet-${var.zones[count.index]}"
}

data "aws_ssm_parameter" "Frontend_sg_id" {
  name = "${local.common}-Frontend-sg"
}

