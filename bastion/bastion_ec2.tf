resource "aws_instance" "bastion" {
  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t2.medium"
  subnet_id = data.aws_ssm_parameter.public_subnet_id_useast1a.value
  vpc_security_group_ids = [ data.aws_ssm_parameter.Bastion_sg_id.value ]
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.bastion_profile.name
  user_data = file("terraform_install.sh")
  
  tags = {
    Name = "bastion-us-east-1a"
  }
}

resource "aws_iam_role" "admin_role" {
  name = "admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "admin_attach" {
  role       = aws_iam_role.admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "bastion_profile" {
  name = "bastion-instance-profile"
  role = aws_iam_role.admin_role.name
}