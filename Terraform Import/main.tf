# Here we are creating a terraform import resource

# first we need to create an EC2 instance manually in aws 

# after the creation of EC2 instance we need to execute this command in terminal

# terraform import aws_instance.ec2_example i-097f1ec37854d01c2 (instance id)

resource "aws_instance" "ec2_example" {
  ami = "ami id of our instance"
  instance_type = "instance type like t2.micro"
  
  tags = {
    Name = "ec2_example" # this is optional you mentioned in creation of instance use that tags here
  }
}

# open terminal and execute the commands 
# terraform plan
# terraform apply


# first we need to create an S3 bucket manually in aws 

# after the creation of S3 bucket we need to execute this command in terminal

# terraform import aws_s3_bucket.my_test_bucket my-demo-bucket.3652

# terraform import aws_s3_bucket_acl.example my-demo-bucket.3652

resource "aws_s3_bucket" "my_test_bucket" {
  bucket = "my-demo-bucket.3652"

  tags = {
    Name = "test-bucket"
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.my_test_bucket.id
}

# open terminal and execute the commands 
# terraform plan
# terraform apply