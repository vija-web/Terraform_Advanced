resource "aws_ssm_parameter" "ami_ids" {
  count = 2
  type  = "String"
  name  = "${local.common}-${var.component}-ami-${var.zones[count.index]}"
  value = "aws_ami_from_instance.${var.component}_ami[count.index].id"
}

resource "aws_ssm_parameter" "target_group_arn" {
  type  = "String"
  name  = "${var.component}-tg-arn"
  value = "aws_lb_target_group.application_tg.arn"
}
