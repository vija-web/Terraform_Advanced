# terraform init is used to get the plugins of the provider
# local-exec means we can execute the commands in the machine where are running the terraform commands

resource "aws_instance" "Terraform" {
  count = length(var.instances)
  ami           = "ami-0220d79f3f480ecf5"
  instance_type = var.instances[count.index] == "mongodb" ? "t3.small" : "t3.small" #if condition in terraform
  vpc_security_group_ids = [ aws_security_group.allow_everything.id ]
  # tags = merge({
  #   Name = var.instances[count.index] #loop 
  # }, var.common_tags)
  tags = merge({
    Name = var.instances[count.index]
  },local.ec2_tags)

  #This will get executed in the machine where terraform files are executing 
  provisioner "local-exec" {
    command = "echo ${self.private_ip} > inventory"
    on_failure = continue
  }

  provisioner "local-exec" {
    command = "echo instance is destroyed"
    on_failure = continue
    when = destroy
  }

  provisioner "remote-exec" {
    inline = [
      "sudo dnf install nginx -y",
      "sudo systemctl start nginx"
    ]
  }

  connection {
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
    host = self.public_ip
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
