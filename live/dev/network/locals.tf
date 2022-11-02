/*locals {

    sg_ids = [aws_security_group.bastion_sg.id, aws_security_group.pub_sg.id]
    sub_id_pub = aws_subnet.publicsubnets.id
    sub_id_priv = aws_subnet.privatesubnets[0].id
    sg_id_priv = [aws_security_group.priv_sg.id, aws_security_group.bastion_sg.id]
    inbound_ports = [22, 8080]
} */