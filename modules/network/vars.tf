variable "main_vpc_cidr" {
    default = "10.0.0.0/24"
}
 variable "public_subnets" {
    default = "10.0.0.128/26"
 }
 variable "private_subnets" {
    default = ["10.0.0.0/26","10.0.0.192/26"]
 }
 variable "instance_subnets" {
    default = ["10.0.0.0/26","10.0.0.128/26"]
 }

 variable "instance_tenancy" {
   default = "default"
 }

 variable "vpc_name" {
   type        = string
   default     = "rr-vpc-ms6"
 }

 variable "public_subnet_name" {
   type        = string
   default     = "rr_public_subnet_ms6"
 }

 variable "igw_name" {
   type        = string
   default     = "rr_igw_ms6"
 }

 variable "public_rt_cidr"{
   default = "0.0.0.0/0"
 }

 variable "public_rt_name" {
   type        = string
   default     = "rr_pub_rt_ms6"
 }

 variable "eip_name"{
   default = "rr_eip_ms6"
 }

 variable "nat_name"{
   default = "rr_Nat_ms6"
 }
 
 variable "private_rt_cidr"{
   default = "0.0.0.0/0"
 }

 variable "private_rt_name" {
   type        = string
   default     = "rr_priv_rt_ms6"
 }
 
 variable "cidr_blocks_sg" {
  default = ["194.117.242.0/26", "195.93.136.0/26"]
 }
 