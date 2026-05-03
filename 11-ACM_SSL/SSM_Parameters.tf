resource "aws_ssm_parameter" "sg_ids" {
  type  = "String"
  name  = "${var.project}-${var.env}-certificate_arn"
  value = aws_acm_certificate.cert.arn
}


 