# terraform init is used to get the plugins of the provider
# There are 3 kind of loops are there in the terraform
# 1. count based loop used for the iteration of the lists as shown below 
#    it will have the special variable count.index
# 2. for_each loop it is used to iterate the map kind of datatype 
#    key and value is accessed by each.key and each.value
# 3. dynamic block loop (As shown in the creation of the security group) in this file itself

# Count loop example
# resource "aws_instance" "Terraform" {
#   count = 4
#   ami           = "ami-0220d79f3f480ecf5"
#   instance_type = var.instances[count.index] == "mongodb" ? "t3.micro" : "t3.small" #if condition in terraform
#   vpc_security_group_ids = [ aws_security_group.allow_everything.id ]
#   tags = {
#     Name = var.instances[count.index] #loop 
#   }
# }

# for_each loop example
resource "aws_instance" "Terraform" {
  for_each = var.instances_map_example
  ami           = "ami-0220d79f3f480ecf5"
  instance_type = each.value
  vpc_security_group_ids = [ aws_security_group.allow_everything.id ]
  tags = {
    Name = each.key 
  }
}

#firt this will execute and will give the output to the resource ec2

resource "aws_security_group" "allow_everything" {
  name        = "allow_everything"
  description = "Allow all the traffic"
  
  # This is block not the map , Map example is shown in the variables.tf file
  egress {  #out going traffic
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  # This is also a block not the map , Map will have variable = key value pairs
  # ingress {  #incoming traffic
  #   from_port        = 0
  #   to_port          = 0
  #   protocol         = "-1"
  #   cidr_blocks      = ["0.0.0.0/0"]
  # }

  dynamic ingress {
    for_each = var.ingress_ports
    content {
      from_port        = ingress.value # Dynamic will give the special keyword (what ever the block name)to use the value
      to_port          = ingress.value
      protocol         = "tcp" # when you open all ports then can give the "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  }

  tags = {
    Name = "allow_tlss"
  }
}
