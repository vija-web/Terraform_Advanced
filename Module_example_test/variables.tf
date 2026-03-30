variable "ami_id" {
    default = "ami-0220d79f3f480ecf5"
}

variable "instance_type" {
    default = "t3.micro"
}

variable "tags" {
    default = {
        Name = "Roboshop-prod",
        terraform = "true"
    }
}