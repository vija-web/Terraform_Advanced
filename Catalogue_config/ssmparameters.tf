resource "aws_ssm_parameter" "ami_ids" {
  count = 2
  type  = "String"
  name  = "${local.common}-catalogue-ami-${var.zones[count.index]}"
  value = "aws_ami_from_instance.catalogue_ami[count.index].id"
}
