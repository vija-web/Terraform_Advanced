resource "aws_instance" "Terraform" {
  ami           = var.ami_id
  instance_type = "t3.micro"
  tags = var.tags
}

