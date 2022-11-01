output "subnets_public"{
    value = aws_subnet.publicsubnets.id
}

output "subnets_private"{
    value = aws_subnet.privatesubnets[1].id
}
output "subnets_priv"{
    value = aws_subnet.privatesubnets[*].id
}
output "sg_id_pub"{
    value = aws_security_group.pub_sg.id
}

output "sg_def_id"{
    value = aws_security_group.bastion_sg.id
}

output "sg_ids" {
    value = local.sg_ids
}

output "sub_id_pub" {
    value = local.sub_id_pub
}

output "sub_id_priv"{
    value = local.sub_id_priv
}

output "sg_ids_priv"{
    value = local.sg_id_priv
}

/*output "subnet_group" {
    value = aws_db_subnet_group.subnet_group.id
}*/