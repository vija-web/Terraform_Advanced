
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
      "sleep 60",
      "chmod 777 /tmp/bootstrap.sh", 
      "sudo sh /tmp/bootstrap.sh Mongodb ${var.project} ${var.environment} ${var.zones[count.index]}"
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
      "sudo sh /tmp/bootstrap.sh Redis ${var.project} ${var.environment} ${var.zones[count.index]}"
    ]
  }
}

resource "aws_instance" "RabbitMQ" {
  count = 2
  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"
  subnet_id = data.aws_ssm_parameter.database_subnet_ids[count.index].value
  vpc_security_group_ids = [ data.aws_ssm_parameter.Rabbitmq_sg_id.value ]

  tags = {
    Name = "RabbitMQ-${var.zones[count.index]}"
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
      "sudo sh /tmp/bootstrap.sh RabbitMQ ${var.project} ${var.environment} ${var.zones[count.index]}"
    ]
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
      "sudo sh /tmp/bootstrap.sh Mysql ${var.project} ${var.environment} ${var.zones[count.index]}"
    ]
  }
}

resource "aws_route53_record" "mongodb" {
  count = 2 
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "mongodb-${var.project}-${var.environment}-${var.zones[count.index]}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.Mongodb[count.index].private_ip]
}

resource "aws_route53_record" "redis" {
  count = 2 
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "redis-${var.project}-${var.environment}-${var.zones[count.index]}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.redis[count.index].private_ip]
}

resource "aws_route53_record" "RabbitMQ" {
  count = 2 
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "rabbitmq-${var.project}-${var.environment}-${var.zones[count.index]}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.RabbitMQ[count.index].private_ip]
}

resource "aws_route53_record" "mysql" {
  count = 2 
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "mysql-${var.project}-${var.environment}-${var.zones[count.index]}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.mysql[count.index].private_ip]
}