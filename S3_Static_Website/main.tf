
# Create an S3 bucket
resource "aws_s3_bucket" "mybucket" {
  bucket = "unique_name for bucket" # use variables here for bucketname

  tags = {
    Name        = "My bucket"
  }
}

# for changing the Ownership for S3 bucket

resource "aws_s3_bucket_ownership_controls" "myownership" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# to provide public access for S3 bucket

resource "aws_s3_bucket_public_access_block" "public" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# to provide access control list for the bucket is 

resource "aws_s3_bucket_acl" "myS3acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.myownership,
    aws_s3_bucket_public_access_block.public,
  ]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}

# To Upload the index.html, Error.html and Profile pic into S3 Bucket

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "index.html"
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "error.html"
  source = "error.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "profile" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "NTR.jpg"
  source = "NTR.jpg"
  acl = "public-read"
}

# For the static website hosting enable and it give end point link for public access

resource "aws_s3_bucket_website_configuration" "website" {
    bucket = aws_s3_bucket.mybucket.id

    index_document {
      suffix = "index.html"
    }

    error_document {
        key = "error.html"
    }

    depends_on = [ aws_s3_bucket_acl.myS3acl ]
}



