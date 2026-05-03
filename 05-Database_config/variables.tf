variable "project" {
    default = "roboshop"
}

variable "environment" {
    default = "dev"
}

variable "zones" {
    type = list
    default = ["us-east-1a" , "us-east-1b"]
}

variable "region_name" {
    default = "us-east-1"
}