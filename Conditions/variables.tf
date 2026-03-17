#variables file

variable "instances" {
    default = [ "mongodb", "redis", "mysql", "rabbitmq" ]
}