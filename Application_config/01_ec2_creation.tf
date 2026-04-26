
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
      "sudo sh /tmp/bootstrap.sh catalogue ${var.project} ${var.environment}"
    ]
  }
}

action "aws_ec2_stop_instance" "example" {
  config {
    instance_id = aws_instance.Catalogue.id
  }
}

resource "aws_ami_from_instance" "catalogue_ami" {
  name               = "catalogue-custom-ami"
  source_instance_id = aws_instance.Catalogue.id

  depends_on = [
    action.aws_ec2_stop_instance.example
  ]

  tags = {
    Name = "catalogue-ami"
  }
}

resource "aws_instance" "Catalogue_latest" {
  count = 2
  ami           = "aws_ami_from_instance.catalogue_ami.id"
  instance_type = "t3.micro"
  subnet_id = data.aws_ssm_parameter.application_subnet_ids[count.index].value
  vpc_security_group_ids = [ data.aws_ssm_parameter.Catalogue_sg_id.value ]

  tags = {
    Name = "${local.common}-Catalogue-${var.zones[count.index]}"
  } 
}

