variable "vpc_tags" {
    type = map
}

variable "cidr_vpc" {
    type = string
}

variable "cidr_subnet" {
    type = list
}

#optional
variable "subnet_tags" {
    type = map
    default = {} 
}

variable "project" {
    type = string
}

variable "env" {
    type = string
}

variable "gateway_tags" {
    type = map
    default = {}
}

variable "nat_tags" {
    type = map
    default = {}
}

variable "eip_tags" {
    type = map
    default = {}
}

variable "tags_public_route_table" {
    type = map
    default = {}
}

variable "tags_application_route_table" {
    type = map
    default = {}
}

variable "tags_database_route_table" {
    type = map
    default = {}
}

variable "region_name" {
    type = string
}