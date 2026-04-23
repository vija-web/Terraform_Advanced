
resource "aws_instance" "Mongodb" {
  count = 2
  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"
  subnet_id = data.aws_ssm_parameter.database_subnet_ids[count.index].value
  vpc_security_group_ids = [ data.aws_ssm_parameter.Mongodb_sg_id.value ]

  tags = {
    Name = "Mongodb-${var.zones[count.index]}"
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
      "sudo sh /tmp/bootstrap.sh "
    ]
  }
}


resource "aws_instance" "redis" {
  count = 2
  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"
  subnet_id = data.aws_ssm_parameter.database_subnet_ids[count.index].value
  vpc_security_group_ids = [ data.aws_ssm_parameter.Redis_sg_id.value ]

  tags = {
    Name = "Redis-${var.zones[count.index]}"
  }
}

resource "aws_instance" "rabbitmq" {
  count = 2
  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"
  subnet_id = data.aws_ssm_parameter.database_subnet_ids[count.index].value
  vpc_security_group_ids = [ data.aws_ssm_parameter.RabbitMQ_sg_id.value ]

  tags = {
    Name = "RabbitMQ-${var.zones[count.index]}"
  }
}

resource "aws_instance" "mysql" {
  count = 2
  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"
  subnet_id = data.aws_ssm_parameter.database_subnet_ids[count.index].value
  vpc_security_group_ids = [ data.aws_ssm_parameter.Mysql_sg_id.value ]

  tags = {
    Name = "Mysql-${var.zones[count.index]}"
  }
}