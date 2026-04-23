# VPC Creation in Terraform

This VPC_Module Repo creates the following resources

* vpc 
* Internet Gateway
* 2 public subnets us-east-1a and us-east-1b
* 2 application subnets us-east-1a and us-east-1b (private subnet)
* 2 database subnets us-east-1a and us-east-1b (private subnet)
* 2 elastic IP for two NAT Gateways
* 2 Nat gateways for us-east-1a and us-east-1b
* 2 public routetables and its routes
* 2 application routetables and its routes
* 2 database routetables and its routes

### Inputs Variables

* vpc_tags - (Required) provide the tags for the vpc you are creating , where the type is Map.

* cidr_vpc - (Required) provide the cidr range for the vpc, where the range should be in the range of 10.0.0.0/16 - 10.0.0.0/24 and type is string.

* cidr_subnet - (Required) provide the list of cidr's for the subnets public, application, database. Type is list.

* subnet_tags - (Optional) provide the tags for the subnet. Type is map

* project - (Required) provide the project name. Type is string

* env - (Required) provide the environment name. Type is string

* gateway_tags - (Optional) provide the tags for the internet gateway. Type is map.

* nat_tags - (Optional) provide the tags for the Nat gateway. Type is map.

* eip_tags - (Optional) provide the tags for the EIP (elastic ip). Type is map.

* tags_public_route_table - (Optional) provide the tags for the public route table. Type is map.

* tags_application_route_table - (Optional) provide the tags for the application route table. Type is map.

* tags_database_route_table - (Optional) provide the tags for the database route table. Type is map.

### Outputs

As per requested we are returning only these values

* All required outputs are provided in the SSM_Parameters.tf file

#### For Sample

* vpc_id - It will return the id of the VPC created.

* public_subnet_ids - It will return the public subnet ids of us-east-1a and     us-east-1b.

