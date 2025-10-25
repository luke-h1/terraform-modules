# Terraform AWS OpenSearch Serverless Module

This module creates an **OpenSearch Serverless** collection that ingests logs from CloudWatch Logs using **Kinesis Data Firehose** for native streaming ingestion. Based on the [AWS OpenSearch Serverless documentation](https://aws.amazon.com/opensearch-service/features/serverless/), this module leverages the serverless capabilities for automatic scaling and cost optimization.

## Features

- **OpenSearch Serverless collection** with encryption and network policies
- **Native streaming ingestion** using Kinesis Data Firehose
- **Automatic scaling** - scales up and down based on demand
- **Pay-per-use pricing** - only pay for resources consumed
- **CloudWatch Logs integration** with subscription filters
- **Optional data processing** with Lambda functions
- **S3 backup** for failed records (optional)

## Benefits of OpenSearch Serverless

- **Get started in seconds** - No cluster provisioning required
- **Scale on demand** - Automatically provisions and adjusts resources
- **Improve costs** - Pay only for what you use
- **Store and search vector embeddings** - Power generative AI applications

## Architecture

```
CloudWatch Logs → Kinesis Data Firehose → OpenSearch Serverless
                     ↓ (optional)
                   S3 Backup
```

## Usage

### Basic Usage

```hcl
module "opensearch_serverless" {
  source = "./terraform-aws-opensearch-serverless"

  collection_name = "my-logs"
  index_name      = "application-logs"
  log_group_names = [
    "/aws/lambda/my-function",
    "/aws/ecs/my-service"
  ]

  tags = {
    Environment = "production"
    Project     = "logging"
  }
}
```

### Advanced Usage with Data Processing

```hcl
module "opensearch_serverless" {
  source = "./terraform-aws-opensearch-serverless"

  collection_name = "my-logs"
  index_name      = "application-logs"
  log_group_names = [
    "/aws/lambda/my-function",
    "/aws/ecs/my-service"
  ]

  # Enable data processing
  enable_data_processing = true
  lambda_processor_arn   = aws_lambda_function.log_processor.arn

  # S3 backup configuration
  s3_backup_bucket_arn = aws_s3_bucket.backup.arn
  s3_backup_prefix     = "opensearch-backup/"

  # Filter specific logs
  filter_pattern = "[timestamp, level, message]"

  tags = {
    Environment = "production"
    Project     = "logging"
  }
}
```

## Requirements

- AWS Provider >= 4.61.0
- Terraform >= 0.12.0

## Variables

| Name                   | Description                                            | Type         | Default              |
| ---------------------- | ------------------------------------------------------ | ------------ | -------------------- |
| collection_name        | Name of the OpenSearch Serverless collection           | string       | "cloudwatch-logs"    |
| index_name             | Name of the OpenSearch index for logs                  | string       | "cloudwatch-logs"    |
| log_group_names        | List of CloudWatch Log Group names to ingest           | list(string) | []                   |
| filter_pattern         | CloudWatch Logs filter pattern for subscription filter | string       | ""                   |
| enable_data_processing | Enable data processing with Lambda function            | bool         | false                |
| lambda_processor_arn   | ARN of Lambda function for data processing             | string       | ""                   |
| retry_duration         | Retry duration in seconds for failed records           | number       | 300                  |
| s3_backup_bucket_arn   | ARN of S3 bucket for backup                            | string       | ""                   |
| s3_backup_prefix       | S3 prefix for backup files                             | string       | "opensearch-backup/" |
| s3_buffering_size      | S3 buffering size in MB                                | number       | 5                    |
| s3_buffering_interval  | S3 buffering interval in seconds                       | number       | 60                   |
| tags                   | Tags to apply to all resources                         | map(string)  | {}                   |

## Outputs

| Name                           | Description                                                |
| ------------------------------ | ---------------------------------------------------------- |
| opensearch_collection_arn      | ARN of the OpenSearch Serverless collection                |
| opensearch_collection_endpoint | Endpoint of the OpenSearch Serverless collection           |
| opensearch_dashboard_endpoint  | Dashboard endpoint of the OpenSearch Serverless collection |
| firehose_delivery_stream_arn   | ARN of the Kinesis Data Firehose delivery stream           |
| firehose_delivery_stream_name  | Name of the Kinesis Data Firehose delivery stream          |
| cloudwatch_logs_role_arn       | ARN of the IAM role for CloudWatch Logs to invoke Firehose |
| firehose_role_arn              | ARN of the IAM role for Firehose to access OpenSearch      |

## Setup

1. **Specify log groups** - Provide the CloudWatch Log Group names you want to ingest
2. **Optional filtering** - Use `filter_pattern` to filter specific log events
3. **Optional processing** - Enable Lambda processing for data transformation
4. **Optional backup** - Configure S3 backup for failed records

## Data Flow

1. **CloudWatch Logs** generate log events
2. **Subscription filters** capture events based on filter pattern
3. **Kinesis Data Firehose** streams data to OpenSearch Serverless
4. **OpenSearch Serverless** automatically scales and indexes the data
5. **Failed records** are backed up to S3 (if configured)

## OpenSearch Serverless Benefits

This module leverages [AWS OpenSearch Serverless](https://aws.amazon.com/opensearch-service/features/serverless/) to provide:

- **Automatic scaling** without manual intervention
- **Cost optimization** by paying only for consumed resources
- **High availability** with built-in redundancy
- **Security** with encryption at rest and in transit
- **Integration** with other AWS services

## Cost Optimization

- **Pay-per-use pricing** - Only pay for what you consume
- **Automatic scaling** - Resources scale down during low usage
- **No cluster management** - No need to provision or manage clusters
- **Efficient ingestion** - Kinesis Data Firehose provides cost-effective streaming

## Security

- **Encryption at rest** with AWS KMS
- **Encryption in transit** with TLS
- **IAM-based access control** for fine-grained permissions
- **Network policies** for VPC integration
- **Data access policies** for collection and index-level access
