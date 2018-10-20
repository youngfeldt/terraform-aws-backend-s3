data "aws_region" "current" { }

variable "backend_dynamodb_lock_table" {
  description = "table to hold state lock when updating.  You may want a distinct one for each separate TF state."
}

variable "backend_s3_bucket" {
  description = "Name of S3 bucket prepared to hold your terraform state(s)"
}

variable "acl" {
  description = "Canned ACL applied to bucket. https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl"
  default     = "bucket-owner-full-control"
}


variable "create_dynamodb_lock_table" {
  default     = false
  description = "Boolean:  If you have a dynamoDB table already, use that one, else make this true and one will be created"
}

variable "create_s3_bucket" {
  default     = false
  description = "Boolean.  If you have an S3 bucket already, use that one, else make this true and one will be created"
}

variable "use_bucket_encryption" {
  default     = false
  description = "Boolean.  Encrypt bucket with account default CMK"
}

variable "use_bucket_versioning" {
  default     = true
  description = "Boolean.  Leave true for safety, or set to false and role the dice on your fate."
}

variable "s3_key" {
  description = "Path to your state.  Examples: dev/tf.state, prod/tf.state, dev/frontend/tf.state, dev/db-tier.tf, etc.."
}
