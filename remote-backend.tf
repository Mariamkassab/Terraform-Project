
resource "aws_s3_bucket" "terraform-state" {
  bucket = "terraform-statefile-mariam"
  lifecycle {
    #    prevent_destroy = true
  }
}



resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform-state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform-lockstate" {
  name         = "terraform-lockstate"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}


terraform {
  backend "s3" {
    bucket         = "terraform-statefile-mariam"
    key            = "terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-lockstate"
    encrypt        = "true"
  }
}