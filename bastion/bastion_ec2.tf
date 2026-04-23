resource "aws_instance" "bastion" {
  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"
  subnet_id = data.aws_ssm_parameter.public_subnet_id_useast1a.value
  vpc_security_group_ids = [ data.aws_ssm_parameter.Bastion_sg_id.value ]
  associate_public_ip_address = true
  
  user_data = file("terraform_install.sh")
  
  tags = {
    Name = "bastion-us-east-1a"
  }
}