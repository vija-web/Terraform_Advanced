
# Creating the temp catalogue server to configure and take the Golden AMI
resource "aws_instance" "Catalogue" {
  count = 2
  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"
  subnet_id = data.aws_ssm_parameter.application_subnet_ids[0].value
  vpc_security_group_ids = [ data.aws_ssm_parameter.Catalogue_sg_id.value ]

  tags = {
    Name = "Catalogue-${var.zones[count.index]}"
  }   
}

# This is null resource , Means it won't create the resource. It will execute after the instance creation
resource "terraform_data" "catalogue" {
  count = 2
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    catalogue_instance_ids = aws_instance.Catalogue[count.index].id
  }
  
  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.Catalogue[count.index].private_ip
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

# before taking the Golden AMI , Its best to stop the server and take the AMI
resource "aws_ec2_instance_state" "stop_instance" {
  count = 2
  instance_id = aws_instance.Catalogue[count.index].id
  state       = "stopped"
  depends_on = [terraform_data.catalogue]
}

# This the golden AMI (using this ami we can directly configure the server)
resource "aws_ami_from_instance" "catalogue_ami" {
  count = 2
  name               = "catalogue-custom-ami-${var.zones[count.index]}"
  source_instance_id = aws_instance.Catalogue[count.index].id

  depends_on = [
    aws_ec2_instance_state.stop_instance
  ]

  tags = {
    Name = "catalogue-ami-${var.zones[count.index]}"
  }
}

resource "aws_launch_template" "catalogue-launch-template" {
  count = 2
  name = "catalogue-${var.project}-${var.environment}-${var.zones[count.index]}"

  image_id = aws_ami_from_instance.catalogue_ami[count.index].id
  instance_type = "t2.micro"
  placement {
    availability_zone = "${var.zones[count.index]}"
  }

  vpc_security_group_ids = [ data.aws_ssm_parameter.Catalogue_sg_id.value ]
}

resource "aws_lb_target_group" "Catalogue_tg" {
  name     = "catalogue-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.roboshop_vpc_id.value

  health_check {
    enabled             = true
    path                = "/health"
    port                = "8080"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
    matcher             = "200-399"
  }

  tags = {
    Name = "catalogue-tg"
  }
}

resource "aws_autoscaling_group" "catalogue" {
  count = 2

  name             = "catalogue-asg-${var.zones[count.index]}"
  desired_capacity = 1
  max_size         = 5
  min_size         = 1

  vpc_zone_identifier = [
    data.aws_ssm_parameter.application_subnet_ids[count.index].value
  ]

  target_group_arns = [
    aws_lb_target_group.Catalogue_tg.arn
  ]

  launch_template {
    id      = aws_launch_template.catalogue-launch-template[count.index].id
    version = "$Latest"
  }
}

# Application Load Balancer
resource "aws_lb" "main_alb" {
  name               = "backend-alb"
  internal           = false
  load_balancer_type = "application"

  # Public subnets in us-east-1a and us-east-1b
  subnets = [
    data.aws_ssm_parameter.public_subnet_ids[0].value,
    data.aws_ssm_parameter.public_subnet_ids[1].value
  ]

  security_groups = [
    data.aws_ssm_parameter.backend_alb_sg_id.value
  ]

  tags = {
    Name = "backend-alb"
  }
}


# HTTP Listener
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.main_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Invalid backend API path"
      status_code  = "404"
    }
  }
}


# Listener Rule for /api/catalogue/
resource "aws_lb_listener_rule" "catalogue_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Catalogue_tg.arn
  }

  condition {
    path_pattern {
      values = ["/api/catalogue*"]
    }
  }
}



