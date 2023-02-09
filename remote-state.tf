# resource "aws_s3_bucket" "terraform-state-backend-bkt" {
#   bucket = "terraform-state-backend-bkt"
#   tags = {
#     Name        = "terraform-state-backend-bkt"
#   }
#   lifecycle {
#     prevent_destroy = true
#   }
# }

# resource "aws_s3_bucket_versioning" "enabled" {
#   bucket = aws_s3_bucket.terraform-state-backend-bkt.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_dynamodb_table" "terraform_locks" {
#   name = "terraform-up-and-running-locks"
#   balling_mode = "PAY_PER_REQUEST"
#   hash_key = "lockID"
#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }

terraform {
  backend "s3"{
    bucket = "terraform-state-backend-bkt"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt = true
  }
}