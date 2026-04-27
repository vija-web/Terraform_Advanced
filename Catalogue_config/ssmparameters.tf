resource "aws_ssm_parameter" "sg_ids" {
  type  = "String"
  name  = "${local.common}-catalogue-ami"
  value = "aws_ami_from_instance.catalogue_ami.id"
}
