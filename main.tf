/*
    S3 Backend setup for TF-STATE mgmt with state locking using dynamodb
    to facilitate concurrent development on environment
*/

data "aws_caller_identity" "current" {}

# S3 Bucket to hold state.
resource "aws_s3_bucket" "s3_backend" {
  count  = "${var.create_s3_bucket}"
  acl    = "private"
  bucket = "${var.backend_s3_bucket}"
  region = "${data.aws_region.current.name}"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags {
    Name      = "TF remote state test"
    Owner     = "${data.aws_caller_identity.current.user_id}"
    Terraform = "true"
  }
}

# DynamoDB table to lock state during applies
resource "aws_dynamodb_table" "terraform_state_lock" {
  count          = "${var.create_dynamodb_lock_table}"
  name           = "${var.backend_dynamodb_lock_table}"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Purpose = "Terraform state lock for state in ${var.backend_s3_bucket}:${var.s3_key} "
  }
}

/* Local file for next init to move state to s3.
   After initial apply, run 
    terraform init -force-copy
   to auto-copy state up to s3
*/
resource "local_file" "terraform_tf" {
  content = <<EOF
    terraform {
      backend "s3" {
        bucket         = "${var.backend_s3_bucket}"
        key            = "${var.s3_key}"
        region         = "${data.aws_region.current.name}"
        encrypt        = false
        dynamodb_table = "${var.backend_dynamodb_lock_table}"
      }
    }
    EOF

  filename = "${path.root}/terraform.tf"
}
