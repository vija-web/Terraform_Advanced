data "aws_route53_zone" "selected" {
  name         = "vijayaws.fun"
}

data "aws_ssm_parameter" "roboshop-certificate" {
  name = "${var.project}-${var.environment}-certificate_arn"
}