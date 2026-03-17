#in locals we can store the expressions and functions and eg: name = "${var.name}.${vae.domain}" 
# we refer like local.name
# in the tf file we no need to show the complex calling and all we can hide in the locals.tf file and can call the names
# it makes the file looks more clear

locals {
    ec2_tags = var.common_tags
}