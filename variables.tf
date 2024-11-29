variable "vpc_name" {
  type = map(string)
  default = {
      "Name" = "terr-vpc"
      "Description" = "vpc created for terraform practical"  
    }
}

variable "vpc_cidr" {
    type = string
    default = "10.20.0.0/16"
}

variable "pub_subnet_cidr" {
    type = string
    default = "10.20.1.0/24"  
}

variable "pub_route_cidr" {
    type = string
    #default = "0.0.0.0/0"  
}

variable "pvt_subnet_cidr" {
    type = string
    default = "10.20.2.0/24"  
}

variable "pub_subnet_name" {
     type = map(string)
    default = {
      "Name" = "public_subnet"
    }
}

variable "pvt_subnet_name" {
    type = map(string)
    default = {
      "Name" = "private_subnet"
    }        
}

variable "ig_name" {
   type = map(string)
    default = {
      "Name" = "terr-IG"
    }
}

variable "nat_ig_name" {
   type = map(string)
    default = {
      "Name" = "terr_NAT_GW"
    }
}


variable "cidr" {
  type=string
  default = "0.0.0.0/0"
  
}

variable "Public_route_table_tag" {
   type = map(string)
    default = {
      "Name" = "public_route_table"
    }
}

variable "instance_type" {
  type = list(string)
  default = ["t2.micro","t2.nano"] 
}

variable "ami" {
  type = list(string)
  default = ["ami-0453ec754f44f9a4a","ami-0453ec754f44f9a4a"] 
}

variable "aws_instant_tag" {
   type = map(string)
    default = {
      "Name" = "MyEC2Instance"
      "Description" = "EC2 created for terraform practical"
    }
}

variable "bastion" {
   type = map(string)
    default = {
      "Name" = "Bastion Host"
      "Description" = "Bastion Host Instance"
    }
}

variable "use_public_ip" {
  description = "Set to true to assign a public IP, false otherwise"
  type = bool
  default = false
}