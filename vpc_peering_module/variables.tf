variable "peer_vpc_id" {
    type = string
    description = "accepctor vpc id"
}

variable "vpc_id" {
    type = string
    description = "requestor vpc id"
}

variable "default_vpc_routetable_id" {
    type = string
}

variable "requester_vpc_cidr" {
    type = string
}

variable "roboshop_vpc_public_subnet_routetable_id" {
    type = string
}

variable "accepctor_vpc_cidr" {
    type = string
}

variable "accepctor_vpc_name" {
    type = string 
    default = "default"
}

variable "requestor_vpc_name" {
    type = string 
    default = "roboshop"
}