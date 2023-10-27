variable "project_Name" {
  type = string
  default = "project"
}

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "dns_support" {
  type = bool
  default = true
}

variable "hostname" {
  type = bool
  default = true
}

variable "web_public-1" {
    type = string
    default = "10.0.1.0/24" 
}

variable "public_ip_launch" {
  type = bool
  default = true
}

variable "web_public-2" {
    type = string
    default = "10.0.2.0/24" 
}

variable "App_private-1" {
    type = string
    default = "10.0.3.0/24" 
}

variable "App_private-2" {
    type = string
    default = "10.0.4.0/24" 
}

variable "DB_private-1" {
    type = string
    default = "10.0.5.0/24" 
}

variable "DB_private-2" {
    type = string
    default = "10.0.6.0/24" 
}

variable "route_cidr" {
  type = string
  default = "0.0.0.0/0"
}

variable "SG_cidr" {
  type = string
  default = "0.0.0.0/0"
}

variable "db_instance" {
  type = string
  default = "db.t2.micro"
}

variable "multi_az" {
  type = bool
  default = true
}