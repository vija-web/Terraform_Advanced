# terraform init is used to get the plugins of the provider
# variables in the variables.tf can be overridden but local variables can not be overidden
# locals are like variables but has many capabilities.
# you can use variables inside the locals, but we can not use variables in another variable
# Generally variables in the variables.tf file can be overidden with the help of terraform.tfvars ...


resource "aws_instance" "Terraform" {
  count = length(var.instances)
  ami           = "ami-0220d79f3f480ecf5"
  instance_type = var.instances[count.index] == "mongodb" ? "t3.micro" : "t3.small" #if condition in terraform
  vpc_security_group_ids = [ aws_security_group.allow_everything.id ]
  # tags = merge({
  #   Name = var.instances[count.index] #loop 
  # }, var.common_tags)
  tags = merge({
    Name = var.instances[count.index]
  },local.ec2_tags)
}

#firt this will execute and will give the output to the resource ec2

resource "aws_security_group" "allow_everything" {
  name        = "allow_everything"
  description = "Allow all the traffic"
  
  egress {  #out going traffic
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {  #incoming traffic
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tlss"
  }
}
