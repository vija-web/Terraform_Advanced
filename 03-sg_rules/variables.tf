variable "instances" {
    default = [
        "Frontend", "Catalogue", "Shipping", "Cart", "Payment" , "User", "Mongodb",
        "Redis", "Mysql", "RabbitMQ" , "backend-alb"
    ]
}

variable "project" {
    default = "roboshop"
}

variable "env" {
    default = "dev"
}

variable "region_name" {
    default = "us-east-1"
}