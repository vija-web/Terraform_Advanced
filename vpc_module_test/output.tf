output "id_of_vpc" {
    value = module.vpc.vpc_id
}

output "id_of_public_subnet" {
    value = module.vpc.public_subnet_id
}