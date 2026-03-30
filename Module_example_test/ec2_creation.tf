module "ec2_creation" {
    source = "../Module_example"
    ami_id = var.ami_id
    instance_type = var.instance_type
    tags = var.tags
}