data "aws_vpc" "requestor_vpc_id" {
  filter {
    name   = "tag:Name"
    values = ["roboshop-vpc"]
  }
}

data "aws_vpc" "default_vpc_id" {
  default = true
}

data "aws_route_table" "defaultvpc_routetable_id" {
  vpc_id = data.aws_vpc.default_vpc_id.id

  filter {
    name   = "association.main"
    values = ["true"]
  }
}

data "aws_subnet" "public_subnet" {
  filter {
    name   = "tag:Name"
    values = ["renault-prod-public"]
  }
}

data "aws_route_table" "roboshop_routable_id" {
  subnet_id = data.aws_subnet.public_subnet.id
}

