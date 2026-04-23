resource "aws_ssm_parameter" "public_subnet_ids" {
  count = 2
  type  = "String"
  name  = "${local.common}-public_subnet-${data.aws_availability_zones.available.names[count.index]}"
  value = "${aws_subnet.public[count.index].id}"
}

resource "aws_ssm_parameter" "application_subnet_ids" {
  count = 2
  type  = "String"
  name  = "${local.common}-application_subnet-${data.aws_availability_zones.available.names[count.index]}"
  value = "${aws_subnet.application[count.index].id}"
}

resource "aws_ssm_parameter" "database_subnet_ids" {
  count = 2
  type  = "String"
  name  = "${local.common}-database_subnet-${data.aws_availability_zones.available.names[count.index]}"
  value = "${aws_subnet.database[count.index].id}"
}

resource "aws_ssm_parameter" "vpc_id" {
  type  = "String"
  name  = "${var.project}-vpc_id"
  value = "${aws_vpc.main.id}"
}

resource "aws_ssm_parameter" "igw_id" {
  type  = "String"
  name  = "${local.common}-igw"
  value = "${aws_internet_gateway.igw.id}"
}

resource "aws_ssm_parameter" "eip_ids" {
  count = 2
  type  = "String"
  name  = "${local.common}-eip-${data.aws_availability_zones.available.names[count.index]}"
  value = "${aws_eip.nat[count.index].id}"
}

resource "aws_ssm_parameter" "nat_ids" {
  count = 2
  type  = "String"
  name  = "${local.common}-nat-${data.aws_availability_zones.available.names[count.index]}"
  value = "${aws_nat_gateway.nat[count.index].id}"
}

resource "aws_ssm_parameter" "public_routetable_ids" {
  count = 2
  type  = "String"
  name  = "${local.common}-public-${data.aws_availability_zones.available.names[count.index]}"
  value = "${aws_route_table.public[count.index].id}"
}

resource "aws_ssm_parameter" "application_routetable_ids" {
  count = 2
  type  = "String"
  name  = "${local.common}-application-${data.aws_availability_zones.available.names[count.index]}"
  value = "${aws_route_table.application[count.index].id}"
}

resource "aws_ssm_parameter" "database_routetable_ids" {
  count = 2
  type  = "String"
  name  = "${local.common}-database-${data.aws_availability_zones.available.names[count.index]}"
  value = "${aws_route_table.database[count.index].id}"
}