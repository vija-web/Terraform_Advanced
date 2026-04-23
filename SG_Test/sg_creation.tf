module "sg_creation" {
    source = "../Security_Groups"
    instances = var.instances
    region_name = var.region_name
    project = var.project
    env = var.env
}