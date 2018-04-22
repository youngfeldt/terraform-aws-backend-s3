data "aws_region" "current" {
  current = true
}

variable "backend_dynamodb_lock_table" {
  description = "table to hold state lock when updating.  You should have a distinct one for each separate TF state."
}

variable "backend_s3_bucket" {
  description = "Name of S3 bucket prepared to hold your terraform state(s)"
}

variable "create_dynamodb_lock_table" {
  default     = false
  description = "Boolean:  If you have a dynamoDB table already, use that one, else make this true and one will be created"
}

variable "create_s3_bucket" {
  default     = false
  description = "Boolean.  If you have an S3 bucket already, use that one, else make this true and one will be created"
}

variable "s3_key" {
  description = "Path to your state.  Examples: dev/tf.state, prod/tf.state, dev/frontend/tf.state, dev/db-tier.tf, etc.."
}
