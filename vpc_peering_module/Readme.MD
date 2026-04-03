# VPC peering with terraform modules

This module creates the vpc peering between two vpc's

# Before this create your vpc through the VPC_Module repo, And create the vpc peering with the created one and with the default vpc.

## Condition for the vpc peering 
* Requestor vpc cidr and accepctor vpc cidr should be distinct
* you can create the peering connection within the same account , different account , different region , different zone.

### Inputs
* peer_vpc_id - (Required) Accepctor vpc id will be given here in this filed and type is string.

* vpc_id - (Required) Requestor vpc id will be given here in this field and the type is string

* default_vpc_routetable_id - (Required) Acceptor vpc routetable id should be given here, because the specific routetable is not created for the default subnet. Type is string

* requester_vpc_cidr - (Required) Requestor vpc cidr range should be given here in this field type is string.

* roboshop_vpc_public_subnet_routetable_id - (Required) Requestor vpc public subnet routable id should be given here, type is string.

* accepctor_vpc_cidr - (Required) Accepctor vpc cidr range should be given here, type is string.

* accepctor_vpc_name - (Optional) Accepctor vpc name should be given here So it was optional default value "default" will be set, type is string.

* requestor_vpc_name - (Optional) Requestor vpc name should be given here So it was optional default value "roboshop" will be set, type is string.

### outputs

* peering_connection_id - It will give the peering connection id.