# terraform init is used to get the plugins of the provider

resource "aws_instance" "Terraform" {
  count = 4
  ami           = "ami-0220d79f3f480ecf5"
  instance_type = var.instance_type
  vpc_security_group_ids = [ aws_security_group.allow_everything.id ]
  tags = {
    Name = var.instances[count.index] #loop 
  }
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

data "aws_instance" "mongodb" {
  instance_id = "id"
}
