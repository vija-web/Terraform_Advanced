locals {
    common = "${var.project}-${var.environment}"
    sg_id = data.aws_ssm_parameter.component_sg_id.value
}