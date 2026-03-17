#variables file

# This is the list (collection of strings)
variable "instances" {
    default = [ "mongodb", "redis", "mysql", "rabbitmq" ]
}

# This is Map
variable "instances_map_example" {
    default = {
        mongodb = "t3.small",
        redis = "t3.small",
        mysql = "t3.small",
        rabbitmq = "t3.small"
    }
}

variable "ingress_ports" {
    default = ["22" , "80" , "3306" , "8080"]
}