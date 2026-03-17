#variables file

variable "instances" {
    default = [ "mongodb", "redis", "mysql", "rabbitmq" ]
}

variable "common_tags" {
    default = {
        project = "roboshop"
        env = "dev"
    }
}
