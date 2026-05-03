locals {
    common = "${var.project}-${var.env}"
    sg_map = {
        Frontend  = data.aws_ssm_parameter.Frontend_sg_id.value
        Catalogue = data.aws_ssm_parameter.Catalogue_sg_id.value
        Cart      = data.aws_ssm_parameter.Cart_sg_id.value
        User      = data.aws_ssm_parameter.User_sg_id.value
        Shipping  = data.aws_ssm_parameter.Shipping_sg_id.value
        Payment   = data.aws_ssm_parameter.Payment_sg_id.value
        Mongodb   = data.aws_ssm_parameter.Mongodb_sg_id.value
        Redis     = data.aws_ssm_parameter.Redis_sg_id.value
        Mysql     = data.aws_ssm_parameter.Mysql_sg_id.value
        RabbitMQ  = data.aws_ssm_parameter.Rabbitmq_sg_id.value
        backend-alb = data.aws_ssm_parameter.backend-alb_sg_id.value
  }
}