module "vpc" {
    source = "../VPC_Module"

    cidr_vpc = var.cidr_vpc
    vpc_tags = var.vpc_tags
    cidr_subnet = var.subnet_cidr
    project = var.project
    env = var.Environment
    region_name = var.region_name
}