resource "aws_ssm_parameter" "sg_ids" {
  count = length(var.instances)
  type  = "String"
  name  = "${local.common}-${var.instances[count.index]}-sg"
  value = "${aws_security_group.sg[count.index].id}"
}


 