variable "cloudwatch_logs_export_bucket" {
  type        = string
  description = "The S3 bucket to export logs to"
}

variable "runtime" {
  type        = string
  description = "The runtime of the lambda function"
  default     = "python3.10"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to all resources"
  default = {
    "Name" : "S3Exporter"
  }
}
