
resource "aws_instance" "Catalogue" {
  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"
  tags = {
    Name = "Catalogue"
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
      "sudo sh /tmp/bootstrap.sh catalogue"
    ]
  }
}
