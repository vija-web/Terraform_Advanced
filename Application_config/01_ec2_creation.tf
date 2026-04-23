
resource "aws_instance" "Catalogue" {
  count = 2
  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"
  subnet_id = data.aws_ssm_parameter.application_subnet_ids[count.index].value
  vpc_security_group_ids = [ data.aws_ssm_parameter.Catalogue_sg_id.value ]

  tags = {
    Name = "Catalogue-${var.zones[count.index]}"
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
      "chmod 777 /tmp/bootstrap.sh", 
      "sudo sh /tmp/bootstrap.sh catalogue"
    ]
  }
}


resource "aws_instance" "Cart" {
  count = 2
  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"
  subnet_id = data.aws_ssm_parameter.application_subnet_ids[count.index].value
  vpc_security_group_ids = [ data.aws_ssm_parameter.Cart_sg_id.value ]

  tags = {
    Name = "Cart-${var.zones[count.index]}"
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
      "chmod 777 /tmp/bootstrap.sh", 
      "sudo sh /tmp/bootstrap.sh cart"
    ]
  }
}

resource "aws_instance" "Shipping" {
  count = 2
  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"
  subnet_id = data.aws_ssm_parameter.application_subnet_ids[count.index].value
  vpc_security_group_ids = [ data.aws_ssm_parameter.Shipping_sg_id.value ]

  tags = {
    Name = "Shipping-${var.zones[count.index]}"
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
      "chmod 777 /tmp/bootstrap.sh", 
      "sudo sh /tmp/bootstrap.sh shipping"
    ]
  }
}

resource "aws_instance" "Payment" {
  count = 2
  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"
  subnet_id = data.aws_ssm_parameter.application_subnet_ids[count.index].value
  vpc_security_group_ids = [ data.aws_ssm_parameter.Payment_sg_id.value ]

  tags = {
    Name = "Payment-${var.zones[count.index]}"
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
      "chmod 777 /tmp/bootstrap.sh", 
      "sudo sh /tmp/bootstrap.sh payment"
    ]
  }
}

resource "aws_instance" "User" {
  count = 2
  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"
  subnet_id = data.aws_ssm_parameter.application_subnet_ids[count.index].value
  vpc_security_group_ids = [ data.aws_ssm_parameter.User_sg_id.value ]

  tags = {
    Name = "User-${var.zones[count.index]}"
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
      "chmod 777 /tmp/bootstrap.sh", 
      "sudo sh /tmp/bootstrap.sh user"
    ]
  }
}