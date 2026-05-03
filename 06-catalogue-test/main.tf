module "application_module_extends_catalogue" {
    source = "../Application_Module"
    project = var.project
    environment = var.environment
    zones = var.zones
    region_name = var.region_name
    domain_name = var.domain_name
    component = var.component
    ami_password = data.aws_ssm_parameter.ami_password.value
}