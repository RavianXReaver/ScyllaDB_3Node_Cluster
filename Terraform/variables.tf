
//Specify the Access key ID in terraform.tfvars
variable "Access_Key_ID" {
    type = string
}

//Specify the Secret Key in terraform.tfvars
variable "Secret_Access_Key" {
    type = string
}

//The Default location is set to Singapore, Feel free to change it to the closest Region
variable "Region" {
    type = string
    default = "ap-southeast-1"
}

variable "VPC_CIDR" {
    type = string
    default = "10.9.8.0/24"
}

// Feel free to change the Instance type according to your node requirements 
// Node requires over 2GB of RAM
variable "Instance_Type" {
    type = string
    default = "t2.medium"
}

variable "Key_Pair_Name" {
    type = string
    default = "Scylla_Cluster"
}

//Subnet A
variable "Subnet_A" {
    type = string
    default = "10.9.8.0/28"
}

//Subnet B
variable "Subnet_B" {
    type = string
    default = "10.9.8.16/28"
}

//Subnet C
variable "Subnet_C" {
    type = string
    default = "10.9.8.32/28"
}

//Locals

locals {
  Subnet_A_AZ = "${var.Region}a" //Availability Zone A
  Subnet_B_AZ = "${var.Region}b" //Availability Zone B
  Subnet_C_AZ = "${var.Region}c" //Availability Zone C
}