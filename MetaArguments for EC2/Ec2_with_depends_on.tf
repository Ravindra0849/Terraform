
resource "aws_instance" "myinstance" {
    ami = ""
    instance_type = "t2.micro"

    depends_on = [      # this instance will depends on s3 bucket
        aws_s3_bucket.mybucket
     ]
        
    tags = {
        Name = "Server"
    }
}

resource "aws_s3_bucket" "mybucket" {
  bucket = "mybucket_Name"
}

