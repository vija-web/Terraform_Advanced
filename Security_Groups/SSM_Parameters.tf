resource "aws_ssm_parameter" "sg_ids" {
  count = length(var.instances)
  type  = "String"
  name  = "${local.common}-${var.instances[count.index]}-sg"
  value = "${aws_security_group.sg[count.index].id}"
}

resource "aws_ssm_parameter" "sg_ids" {
  type  = "String"
  name  = "application_sg"
  value = "${aws_security_group.Application_sg.id}
}

