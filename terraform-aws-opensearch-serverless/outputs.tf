output "opensearch_collection_arn" {
  description = "ARN of the OpenSearch Serverless collection"
  value       = aws_opensearchserverless_collection.main.arn
}

output "opensearch_collection_endpoint" {
  description = "Endpoint of the OpenSearch Serverless collection"
  value       = aws_opensearchserverless_collection.main.collection_endpoint
}

output "opensearch_dashboard_endpoint" {
  description = "Dashboard endpoint of the OpenSearch Serverless collection"
  value       = aws_opensearchserverless_collection.main.dashboard_endpoint
}

output "firehose_delivery_stream_arn" {
  description = "ARN of the Kinesis Data Firehose delivery stream"
  value       = aws_kinesis_firehose_delivery_stream.opensearch.arn
}

output "firehose_delivery_stream_name" {
  description = "Name of the Kinesis Data Firehose delivery stream"
  value       = aws_kinesis_firehose_delivery_stream.opensearch.name
}

output "cloudwatch_logs_role_arn" {
  description = "ARN of the IAM role for CloudWatch Logs to invoke Firehose"
  value       = aws_iam_role.cloudwatch_logs_role.arn
}

output "firehose_role_arn" {
  description = "ARN of the IAM role for Firehose to access OpenSearch"
  value       = aws_iam_role.firehose_role.arn
}
