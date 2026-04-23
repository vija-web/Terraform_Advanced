resource "aws_security_group" "sg" {
  count = length(var.instances)
  name = "${local.common}-${var.instances[count.index]}-sg"
  vpc_id = data.aws_ssm_parameter.roboshop_vpc_id.value
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group_rule" "allow_ssh" {
  count = length(local.private_instances)
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"

  security_group_id        = aws_security_group.sg[count.index + 1].id
  source_security_group_id = aws_security_group.sg[0].id
}
