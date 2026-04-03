module "vpc_peering_creation" {
    source = "../vpc_peering_module"

    peer_vpc_id = data.aws_vpc.requestor_vpc_id.id
    vpc_id = data.aws_vpc.default_vpc_id.id
    default_vpc_routetable_id = data.aws_route_table.defaultvpc_routetable_id.id
    requester_vpc_cidr = data.aws_vpc.requestor_vpc_id.cidr_block
    roboshop_vpc_public_subnet_routetable_id = data.aws_route_table.roboshop_routable_id.id
    accepctor_vpc_cidr = data.aws_vpc.default_vpc_id.cidr_block
    accepctor_vpc_name = var.accepctor_vpc_name
    requestor_vpc_name = var.requestor_vpc_name
}