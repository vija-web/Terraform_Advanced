variable "instances" {
    default = [
        "Bastion", "Frontend", "Catalogue", "Shipping", "Cart", "Payment" , "User", "Mongodb",
        "Redis", "Mysql", "RabbitMQ" , "backend-alb"
    ]
}

variable "region_name" {
    default = "us-east-1"
}

variable "project" {
    default = "roboshop"
}

variable "env" {
    default = "dev"
}
