
resource "aws_instance" "Frontend" {
  count = 2
  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"
  subnet_id = data.aws_ssm_parameter.public_subnet_ids[count.index].value
  vpc_security_group_ids = [ data.aws_ssm_parameter.Frontend_sg_id.value ]
  associate_public_ip_address = true

  tags = {
    Name = "Frontend-${var.zones[count.index]}"
  }
  
  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = self.private_ip
  }

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 60",
      "chmod 777 /tmp/bootstrap.sh", 
      "sudo sh /tmp/bootstrap.sh frontend"
    ]
  }
}
