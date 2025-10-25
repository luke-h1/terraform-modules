variable "collection_name" {
  type        = string
  description = "Name of the OpenSearch Serverless collection"
  default     = "cloudwatch-logs"
}

variable "index_name" {
  type        = string
  description = "Name of the OpenSearch index for logs"
  default     = "cloudwatch-logs"
}

variable "log_group_names" {
  type        = list(string)
  description = "List of CloudWatch Log Group names to ingest"
  default     = []
}

variable "filter_pattern" {
  type        = string
  description = "CloudWatch Logs filter pattern for subscription filter"
  default     = ""
}

variable "enable_data_processing" {
  type        = bool
  description = "Enable data processing with Lambda function"
  default     = false
}

variable "lambda_processor_arn" {
  type        = string
  description = "ARN of Lambda function for data processing (optional)"
  default     = ""
}

variable "retry_duration" {
  type        = number
  description = "Retry duration in seconds for failed records"
  default     = 300
}

variable "s3_backup_bucket_arn" {
  type        = string
  description = "ARN of S3 bucket for backup (optional)"
  default     = ""
}

variable "s3_backup_prefix" {
  type        = string
  description = "S3 prefix for backup files"
  default     = "opensearch-backup/"
}

variable "s3_buffering_size" {
  type        = number
  description = "S3 buffering size in MB"
  default     = 5
}

variable "s3_buffering_interval" {
  type        = number
  description = "S3 buffering interval in seconds"
  default     = 60
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to all resources"
  default = {
    Name = "OpenSearchServerless"
  }
}
