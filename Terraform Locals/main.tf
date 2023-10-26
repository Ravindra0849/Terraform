# This is the code syntax without any local variable

/* resource "aws_vpc" "myVPC" {
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "staging_VPC"
  }
}

resource "aws_subnet" "Public" {
  vpc_id = aws_vpc.myVPC.id
  cidr_block = "10.1.1.0/16"

  tags = {
    Name = "staging_Public_Subnet"
  }
}

resource "aws_subnet" "Private" {
  vpc_id = aws_vpc.myVPC.id
  cidr_block = "10.1.2.0/16"

  tags = {
    Name = "staging_Private_Subnet"
  }
}*/  #(This is an Uncommit code)

# This resources are created for staging area
# Here locals are used to passing the variable for repeated words. in this scenario staging is repeated.
# I need to use same code for Dev/Prod, I need to changing in every line, to avoid this i will pass local Variables.
# So the code Will be

provider "aws" {
  # Configuration options
  region = "us-east-1"
}

locals {
  environment = "staging"
}

resource "aws_vpc" "myVPC" {
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "${local.environment}_VPC"
  }
}

resource "aws_subnet" "Public" {
  vpc_id = aws_vpc.myVPC.id
  cidr_block = "10.1.1.0/16"

  tags = {
    Name = "${local.environment}_Public_Subnet"
  }
}

resource "aws_subnet" "Private" {
  vpc_id = aws_vpc.myVPC.id
  cidr_block = "10.1.2.0/16"

  tags = {
    Name = "${local.environment}_Private_Subnet"
  }
}

