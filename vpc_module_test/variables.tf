variable "vpc_tags" {
    default = {
        Name = "roboshop-vpc",
        terraform = "true"
    }
}

variable "cidr_vpc" {
    default = "10.0.0.0/16"
}

variable "subnet_cidr" {
    default = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
}

variable "project" {
    default = "renault"
}

variable "Environment" {
    default = "prod"
}