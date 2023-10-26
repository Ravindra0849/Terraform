# here we are creating the instance along with Bootstrap scripts. these can be in 2 types along with tf file and create separate file for userdata. 

# this is the first type

resource "aws_instance" "name" {
   ami = ""
   instance_type = "t2.micro"
   key_name = "virginia"
   /*user_data = << EOF  [# here /* is used for comment the code without execution, for execution remove /* in both sides]
		#! /bin/bash
    sudo apt-get update
		sudo apt-get install -y apache2
		sudo systemctl start apache2
		sudo systemctl enable apache2
		echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
	EOF */

}

# This is the second way of approach in better way for this we need to create separate script.sh files

resource "aws_instance" "name" {
   ami = ""
   instance_type = "t2.micro"
   key_name = "virginia"
   user_data = file(script.sh)
    
    tags = {
		  Name = "Terraform"	
	}
}