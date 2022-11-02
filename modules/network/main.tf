# VPC

resource "aws_vpc" "Main" {                
   cidr_block       = var.main_vpc_cidr 
   instance_tenancy = var.instance_tenancy

   tags = {
    Name = var.vpc_name
    name = var.vpc_name
   }
 }

# SUBNETS
 resource "aws_subnet" "publicsubnets" { 
   vpc_id =  aws_vpc.Main.id
   cidr_block = var.public_subnets

   depends_on = [aws_internet_gateway.IGW]
   
   tags = { 
    Name = var.public_subnet_name

   }
   }        
 
 resource "aws_subnet" "privatesubnets" {
   count = "${length(var.private_subnets)}"
   vpc_id =  aws_vpc.Main.id
   cidr_block = "${var.private_subnets[count.index]}"
   availability_zone = data.aws_availability_zones.available.names[count.index]
   tags = {
    Name = "private${count.index}_subnet_radaur_ms5"
   }            
 }


 #IGW

 resource "aws_internet_gateway" "IGW" {    # Creating Internet Gateway
    vpc_id =  aws_vpc.Main.id               # vpc_id will be generated after we create VPC
 
    tags = {
      Name = var.igw_name
    } 
 }


 #EIP


 resource "aws_eip" "raduIP" {
   vpc   = true

   tags = {
    Name = var.eip_name
   }
 }


#Nat Gateway

 resource "aws_nat_gateway" "NATgw" {
   allocation_id = aws_eip.raduIP.id
   subnet_id = aws_subnet.publicsubnets.id

   tags = {
    Name = var.nat_name
   }
 }


# RT

 resource "aws_route_table" "PublicRT" {    # Creating RT for Public Subnet
    vpc_id =  aws_vpc.Main.id
         route {
    cidr_block = var.public_rt_cidr               # Traffic from Public Subnet reaches Internet via Internet Gateway
    gateway_id = aws_internet_gateway.IGW.id
     }

     tags = {
      Name = var.public_rt_name
     }
 }


 resource "aws_route_table" "PrivateRT" {    
   vpc_id = aws_vpc.Main.id
   route {
   cidr_block = var.private_rt_cidr             # Traffic from Private Subnet reaches Internet via NAT Gateway
   nat_gateway_id = aws_nat_gateway.NATgw.id
   }

   tags = {
    Name = var.private_rt_name
   }
 }

# RT Association
 resource "aws_route_table_association" "PublicRTassociation" {
    subnet_id = aws_subnet.publicsubnets.id
    route_table_id = aws_route_table.PublicRT.id
 }

 resource "aws_route_table_association" "PrivateRTassociation" {
    count = "${length(var.private_subnets)}"
      subnet_id = "${element(aws_subnet.privatesubnets.*.id, count.index)}"
      route_table_id = aws_route_table.PrivateRT.id
 }

#aws_vpc.Main.id-->vpc_id

# SG

  resource "aws_security_group" "pub_sg" {

    description = "Security group for public subnet"

    name = var.pub_sg_name

    vpc_id = aws_vpc.Main.id

    tags = {

        Name = var.pub_sg_name

    }

    #description = "In-bound internal rules for ssh"

    ingress{

    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = var.cidr_blocks_sg

    }

#   description = "Outbound to all web, any protocol"

    egress{

    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.pub_sg_e_cidr]

    }
}

resource "aws_security_group" "priv_sg" {

    description = "Security group for private subnets"

    name = var.sg_pv_name

    vpc_id = aws_vpc.Main.id

    tags = {

        Name = var.sg_pv_Name

    }



#    description = "Outbound to all web, any protocol"

    egress{

    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.priv_sg_e_cidr]
    }
}



resource "aws_security_group" "bastion_sg" {

    description = "Security group for private subnets"

    name = var.bastion_sg_name

    vpc_id = aws_vpc.Main.id

    tags = {

        Name = var.bastion_sg_Name

    }

    #description = "In-bound internal rules for ssh"

    dynamic "ingress" {
      for_each = local.inbound_ports
      content {
        from_port = ingress.value
        to_port = ingress.value
        protocol = "tcp"
        cidr_blocks = var.cidr_blocks_sg
      }
    }

}


#SG rules
resource "aws_security_group_rule" "inbound_bastion_ssh_private" {

    type = "ingress"

    from_port = 22

    to_port = 22

    protocol = "tcp"

    source_security_group_id = aws_security_group.bastion_sg.id

    security_group_id = aws_security_group.priv_sg.id

}

resource "aws_security_group_rule" "in_mysql_pub" {   #de mutat in sg_pub
    description = ""
    type = "ingress"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    security_group_id = aws_security_group.pub_sg.id
}

resource "aws_security_group_rule" "in_mysql_priv" {
    description = ""
    type = "ingress"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    security_group_id = aws_security_group.priv_sg.id
}

# Subnet Group
/*resource "aws_db_subnet_group" "subnet_group" {
  name = "main_subnet_group"
  subnet_ids = [aws_subnet.privatesubnets[0].id,aws_subnet.privatesubnets[1].id]

  tags = {
    Name = "db_sb_group_rr"
  }
}
*/
#Data source

data "aws_availability_zones" "available" {
  state = "available"
}

#remotestate

terraform {
  backend "s3" {
    bucket         = "rr-s3-bucket-ms6-tfstate"
    key            = "modules/network/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "student-rr-radaur_ms5_l"
  }
}