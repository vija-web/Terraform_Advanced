
resource "aws_instance" "Catalogue" {
  count = 2
  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"
  subnet_id = data.aws_ssm_parameter.application_subnet_ids[0].value
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
      "sleep 60",
      "chmod 777 /tmp/bootstrap.sh", 
      "sudo sh /tmp/bootstrap.sh catalogue ${var.project} ${var.environment} ${var.zones[count.index]}"
    ]
  }
}

resource "aws_ami_from_instance" "catalogue_ami" {
  count = 2
  name               = "catalogue-custom-ami"
  source_instance_id = aws_instance.Catalogue[count.index].id

  depends_on = [
    aws_instance.Catalogue
  ]

  tags = {
    Name = "catalogue-ami-${var.zones[count.index]}"
  }
}

resource "aws_instance" "Catalogue_latest" {
  count = 2
  ami           = aws_ami_from_instance.catalogue_ami[count.index].id
  instance_type = "t3.micro"
  subnet_id = data.aws_ssm_parameter.application_subnet_ids[count.index].value
  vpc_security_group_ids = [ data.aws_ssm_parameter.Catalogue_sg_id.value ]

  tags = {
    Name = "${local.common}-Catalogue-${var.zones[count.index]}"
  } 
}

