resource "aws_s3_bucket" "iac-bucket" {
  bucket = "iac-bucket-my-tf-test-bucket"

  tags = {
    Name        = "iac-bucket"
    Environment = "Prod"
  }
}