variable "project"{
    type = string
}

variable "env" {
    type = string
  
}

variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}


variable "vpc_tags" {
    type = map 
    default = {}
  
}

variable "igw_tags" {
    type = map
    default = {}
  
}

variable "public_subnet" {

    default = ["10.0.1.0/24" , "10.0.2.0/24"]
}

variable "public_subnet_tags" {
    type = map
    default = {}
  
}


variable "private_subnet" {

    default = ["10.0.11.0/24" , "10.0.12.0/24"]
}

variable "private_subnet_tags" {
    type = map
    default = {}
  
}


variable "db_subnet" {
    
    default = ["10.0.21.0/24" , "10.0.22.0/24"]
}

variable "private_db_tags" {
    
    default = {}
  
}




variable "public_route_table_tags" {
    
    default = {}
  
}


variable "private_route_table_tags" {
    type = map
    default = {}
  
}



variable "db_route_table_tags" {
    type = map
    default = {}
  
}


variable "eip_tags" {
    type = map
    default = {}
}




variable "nat_gateway_tags" {
    type = map
    default = {}
}

