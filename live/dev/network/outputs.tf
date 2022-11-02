output "subnets_public"{
    value = module.network.subnets_public
}

output "subnets_private"{
    value = module.network.subnets_private
}
output "subnets_priv"{
    value = module.network.subnets_priv
}
output "sg_id_pub"{
    value = module.network.sg_id_pub
}

output "sg_def_id"{
    value = module.network.sg_def_id
}

output "sg_ids" {
    value = module.network.sg_ids
}

output "sub_id_pub" {
    value = module.network.sub_id_pub
}

output "sub_id_priv"{
    value = module.network.sub_id_priv
}

output "sg_ids_priv"{
    value = module.network.sg_ids_priv
}