
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.19.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"          # here Access_Key and Secret_key are encrypted 
}

# here iam creating multiple  user for the IAM 

resource "aws_iam_user" "myIAM" {
  count = length(var.user_name)
  name = var.user_name [count.index]
}

variable "user_name" {
  description = "IAM usernames"
  type = list(string)
  default = [ "user1", "user2", "user3", "user4"]
}

# here we are creating EC2 Instance 

resource "aws_instance" "new_EC2" {
  ami = ""
  instance_type = "t2.micro"
  key_name = "virginia"
  count = 1

  tags = {
    Name = "New_EC2"
  }
}