# Create S3 Bucket

resource "aws_s3_bucket" "mybucket" {
  bucket = "s3statebackend2563"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# Create dynamoDB

resource "aws_dynamodb_table" "mydynamodb" {
  name = "state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}