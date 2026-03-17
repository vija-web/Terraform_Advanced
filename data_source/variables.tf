variable "instance_type" {
    default = "t2.micro"
}

variable "instances" {
    default = [ "mongodb", "redis", "mysql", "rabbitmq" ]
}