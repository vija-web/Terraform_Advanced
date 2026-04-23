locals {
    common = "${var.project}-${var.env}"
    private_instances = [
        for instance in var.instances : instance
        if lower(instance) != "bastion"
    ]
}
