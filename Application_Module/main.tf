
# Creating the temp application server to configure and take the Golden AMI
resource "aws_instance" "main" {
  count = 2
  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"
  subnet_id = data.aws_ssm_parameter.application_subnet_ids[count.index].value
  vpc_security_group_ids = [ "data.aws_ssm_parameter.${var.component}_sg_id.value" ]

  tags = {
    Name = "${var.component}-${var.zones[count.index]}"
  }   
}

# This is null resource , Means it won't create the resource. It will execute after the instance creation
resource "terraform_data" "main" {
  count = 2
  # Changes to any instance of the cluster requires re-provisioning
  triggers_replace = {
    instance_ids = aws_instance.main[count.index].id
  }
  
  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = data.ami_password
    host     = aws_instance.main[count.index].private_ip
  }

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 60",
      "chmod 777 /tmp/bootstrap.sh", 
      "sudo sh /tmp/bootstrap.sh ${var.component} ${var.project} ${var.environment} ${var.zones[count.index]}"
    ]
  }
}

# before taking the Golden AMI , Its best to stop the server and take the AMI
resource "aws_ec2_instance_state" "stop_instance" {
  count = 2
  instance_id = aws_instance.main[count.index].id
  state       = "stopped"
  depends_on = [terraform_data.main]
}

# This the golden AMI (using this ami we can directly configure the server)
resource "aws_ami_from_instance" "golden_ami" {
  count = 2
  name               = "${var.component}-custom-ami-${var.zones[count.index]}"
  source_instance_id = aws_instance.main[count.index].id

  depends_on = [
    aws_ec2_instance_state.stop_instance
  ]

  tags = {
    Name = "${var.component}-ami-${var.zones[count.index]}"
  }
}


resource "aws_launch_template" "application-launch-template" {
  count = 2
  name = "${var.component}-${var.project}-${var.environment}-${var.zones[count.index]}"

  image_id = aws_ami_from_instance.golden_ami[count.index].id
  instance_type = "t3.micro"

  # when we do terraform apply 2nd time then new varsion will be created with new ami
  update_default_version = true
  vpc_security_group_ids = [ "data.aws_ssm_parameter.${var.component}_sg_id.value" ]

  tags = {
    Name = "${var.component}-LT-${var.zones[count.index]}"
  }
}

resource "aws_lb_target_group" "application_tg" {
  name     = "${var.component}-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.roboshop_vpc_id.value

  health_check {
    enabled             = true
    path                = "/health"
    port                = "8080"
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 15
    matcher             = "200-399"
  }

  tags = {
    Name = "${var.component}-tg"
  }
}

resource "aws_autoscaling_group" "application" {
  count = 2

  name             = "${var.component}-asg-${var.zones[count.index]}"
  desired_capacity = 1
  max_size         = 5
  min_size         = 1

  vpc_zone_identifier = [
    data.aws_ssm_parameter.application_subnet_ids[count.index].value
  ]

  target_group_arns = [
    aws_lb_target_group.application_tg.arn
  ]

  launch_template {
    id      = aws_launch_template.application-launch-template[count.index].id
    version = "$Latest" 
    # takes the latest version of the launch template
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50 # atlest 50% instances should be live
    }
    triggers = ["launch_template"]
  }

  health_check_type         = "ELB"
  health_check_grace_period = 60
  default_cooldown          = 60
}

resource "aws_autoscaling_policy" "application_cpu_policy" {
  count                  = 2
  name                   = "${var.component}-cpu-policy-${var.zones[count.index]}"
  autoscaling_group_name = aws_autoscaling_group.application[count.index].name

  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 75.0
  }

  estimated_instance_warmup = 60
}
