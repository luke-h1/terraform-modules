variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket which holds terraform state"
}

variable "table_name" {
  type        = string
  default     = "tf-lock"
  description = "The name of the dynamoDB lock table"
}