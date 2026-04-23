
data "aws_ssm_parameter" "public_subnet_id_useast1a" {
  name = "${local.common}-public_subnet-us-east-1a"
}

data "aws_ssm_parameter" "Bastion_sg_id" {
  name = "${local.common}-Bastion-sg"
}