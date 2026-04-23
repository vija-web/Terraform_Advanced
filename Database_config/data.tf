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

data "aws_ssm_parameter" "database_subnet_ids" {
  count = 2
  name = "${local.common}-database_subnet-${var.zones[count.index]}"
}

data "aws_ssm_parameter" "Mongodb_sg_id" {
  name = "${local.common}-Mongodb-sg"
}

data "aws_ssm_parameter" "Redis_sg_id" {
  name = "${local.common}-Redis-sg"
}

data "aws_ssm_parameter" "Rabbitmq_sg_id" {
  name = "${local.common}-Rabbitmq-sg"
}

data "aws_ssm_parameter" "Mysql_sg_id" {
  name = "${local.common}-Mysql-sg"
}