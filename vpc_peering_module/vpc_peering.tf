resource "aws_vpc_peering_connection" "foo" {

  peer_vpc_id   = var.peer_vpc_id          #accepctor roboshop vpc id
  vpc_id        = var.vpc_id               #requestor default vpc id
  auto_accept   = true
  tags = {
    Name = local.peering_name
  }
}

resource "aws_route" "default_routetable" {
  route_table_id            = var.default_vpc_routetable_id
  destination_cidr_block    = var.requester_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.foo.id
}

resource "aws_route" "roboshop_routetable" {
  route_table_id            = var.roboshop_vpc_public_subnet_routetable_id
  destination_cidr_block    = var.accepctor_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.foo.id
}

