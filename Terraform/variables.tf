
variable "Access_Key_ID" {
    type = string
}

variable "Secret_Access_Key" {
    type = string
}

variable "Region" {
    type = string
    default = "ap-southeast-1"
}

variable "VPC_CIDR" {
    type = string
    default = "10.9.8.0/24"
}

variable "AMI" {
    type = string
    default = "ami-0c20b8b385217763f"
}   

variable "Instance_Type" {
    type = string
    default = "t2.large"
}

variable "Key_Pair_Name" {
    type = string
    default = "Scylla_Cluster"
}

//Subnets

//Subnet A
variable "Subnet_A" {
    type = string
    default = "10.9.8.0/28"
}

variable "Subnet_A_AZ" {
    type = string
    default = "ap-southeast-1a"
}

//Subnet B
variable "Subnet_B" {
    type = string
    default = "10.9.8.16/28"
}

variable "Subnet_B_AZ" {
    type = string
    default = "ap-southeast-1b"
}

//Subnet C
variable "Subnet_C" {
    type = string
    default = "10.9.8.32/28"
}

variable "Subnet_C_AZ" {
    type = string
    default = "ap-southeast-1c"
}