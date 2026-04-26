# 1. Create the S3 bucket
resource "aws_s3_bucket" "s3_test" {
  bucket = "devops-test-rohit"
}

# 2. Enable versioning for that specific bucket
resource "aws_s3_bucket_versioning" "s3_test_versioning" {
  bucket = aws_s3_bucket.s3_test.id
  versioning_configuration {
    status = "Enabled"
  }
}

