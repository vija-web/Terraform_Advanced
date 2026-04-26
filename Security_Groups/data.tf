data "aws_availability_zones" "available" {
  state = "available"
  region = var.region_name
}

data "aws_ssm_parameter" "roboshop_vpc_id" {
  name = "${var.project}-vpc_id"
}

data "aws_security_group" "application_sg" {
  name = "application_sg"
}
