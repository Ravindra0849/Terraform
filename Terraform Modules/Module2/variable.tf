
variable "ami_id" {
  type = string
  description = "AMI ID of ec2 machine"
  default = "ami-0767046d1677be5a0"
}

variable "instance_type" {
  type = string
  description = "Instance type"
  default = "t2.micro"
}

variable "key_name" {
  type = string
  default = "virginia"
}

variable "count" {
  type = number
  default = 2
}

variable "cidr_block" {
  type = string
  description = "Cidr block range"
  default = "10.0.0.0/16"
}

variable "Public_Subnet" {
  type = string
  default = "10.0.1.0/24"
}

variable "Private_Subnet" {
  type = string
  default = "10.0.2.0/24"
}

variable "RT_Cidr" {
  type = string
  default = "0.0.0.0/0"
}

