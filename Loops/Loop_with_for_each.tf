
# Here we are creating the Loops with for_each 

provider "aws" {
  # Configuration options
  region = "us-east-1"          # here Access_Key and Secret_key are encrypted 
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

# here iam creating multiple  user for the IAM 

variable "user_names" {
  description = "IAM usernames"
  type = set(string)    #  here we can use set/map
  default = [ "user1", "user2", "user3",]
}

resource "aws_iam_user" "myIAM" {
  for_each = length(var.user_names)
  name = each.value
}

