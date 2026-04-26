resource "aws_vpc" "main" {
  cidr_block       = var.cidr_vpc
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = merge({
    Name = "${local.common}-vpc"
  },var.vpc_tags)
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge({
    Name = "${local.common}-igw" } , var.gateway_tags)
}

resource "aws_subnet" "public" {
  count = 2
  vpc_id     = aws_vpc.main.id
  cidr_block = slice(var.cidr_subnet, 0, 2)[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge({
    Name = "${local.common}-public-${data.aws_availability_zones.available.names[count.index]}"
  },var.subnet_tags)
}

resource "aws_subnet" "application" {
  count = 2
  vpc_id     = aws_vpc.main.id
  cidr_block = slice(var.cidr_subnet, 2, 4)[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge({
    Name = "${local.common}-application-${data.aws_availability_zones.available.names[count.index]}"
  },var.subnet_tags)
}

resource "aws_subnet" "database" {
  count = 2
  vpc_id     = aws_vpc.main.id
  cidr_block = slice(var.cidr_subnet, 4, 6)[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge({
    Name = "${local.common}-database-${data.aws_availability_zones.available.names[count.index]}"
  },var.subnet_tags)
}

resource "aws_eip" "nat" {
  count = 2
  domain   = "vpc"

  tags = merge({
    Name = "${local.common}-eip-${data.aws_availability_zones.available.names[count.index]}"
  },var.eip_tags)
}

resource "aws_nat_gateway" "nat" {
  count = 2
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge({
    Name = "${local.common}-nat-${data.aws_availability_zones.available.names[count.index]}"
  },var.nat_tags)

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public" {
  count = 2
  vpc_id = aws_vpc.main.id

  tags = merge({
    Name = "${local.common}-public-${data.aws_availability_zones.available.names[count.index]}"
  },var.tags_public_route_table)
}

resource "aws_route_table" "application" {
  vpc_id = aws_vpc.main.id
  count = 2
  tags = merge({
    Name = "${local.common}-application-${data.aws_availability_zones.available.names[count.index]}"
  },var.tags_application_route_table)
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id
  count = 2
  tags = merge({
    Name = "${local.common}-database-${data.aws_availability_zones.available.names[count.index]}"
  },var.tags_database_route_table)
}

resource "aws_route" "public" {
  count = 2
   route_table_id            = aws_route_table.public[count.index].id
   destination_cidr_block    = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route" "application" {
  count = 2
   route_table_id            = aws_route_table.application[count.index].id
   destination_cidr_block    = "0.0.0.0/0"
   nat_gateway_id = aws_nat_gateway.nat[count.index].id
}

resource "aws_route" "database" {
  count = 2
   route_table_id            = aws_route_table.database[count.index].id
   destination_cidr_block    = "0.0.0.0/0"
   nat_gateway_id = aws_nat_gateway.nat[count.index].id
}

resource "aws_route_table_association" "public" {
  count = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

resource "aws_route_table_association" "application" {
  count = 2
  subnet_id      = aws_subnet.application[count.index].id
  route_table_id = aws_route_table.application[count.index].id
}

resource "aws_route_table_association" "database" {
  count = 2
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database[count.index].id
}