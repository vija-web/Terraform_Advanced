resource "aws_vpc" "main" {
  cidr_block       = var.cidr_vpc
  instance_tenancy = "default"
  enable_dns_support = true

  tags = var.vpc_tags
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge({
    Name = "${local.common}-igw" } , var.gateway_tags)
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_subnet[0]

  tags = merge({
    Name = "${local.common}-public"
  },var.subnet_tags)
}

resource "aws_subnet" "application" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_subnet[1]

  tags = merge({
    Name = "${local.common}-application"
  },var.subnet_tags)
}

resource "aws_subnet" "database" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_subnet[2]

  tags = merge({
    Name = "${local.common}-database"
  },var.subnet_tags)
}

resource "aws_eip" "nat" {
  domain   = "vpc"

  tags = merge({
    Name = "${local.common}-eip"
  },var.eip_tags)
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = merge({
    Name = "${local.common}-nat"
  },var.nat_tags)

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge({
    Name = "${local.common}-public"
  },var.tags_public_route_table)
}

resource "aws_route_table" "application" {
  vpc_id = aws_vpc.main.id

  tags = merge({
    Name = "${local.common}-application"
  },var.tags_application_route_table)
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge({
    Name = "${local.common}-database"
  },var.tags_database_route_table)
}

resource "aws_route" "public" {
   route_table_id            = aws_route_table.public.id
   destination_cidr_block    = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route" "application" {
   route_table_id            = aws_route_table.application.id
   destination_cidr_block    = "0.0.0.0/0"
   nat_gateway_id = aws_nat_gateway.nat.id
}

resource "aws_route" "database" {
   route_table_id            = aws_route_table.database.id
   destination_cidr_block    = "0.0.0.0/0"
   nat_gateway_id = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "application" {
  subnet_id      = aws_subnet.application.id
  route_table_id = aws_route_table.application.id
}

resource "aws_route_table_association" "database" {
  subnet_id      = aws_subnet.database.id
  route_table_id = aws_route_table.database.id
}