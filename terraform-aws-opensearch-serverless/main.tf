terraform {
  required_version = ">= 0.12.0"

  required_providers {
    aws = {
      version = ">= 4.61.0"
    }
    random = {
      version = ">= 3.4.0"
    }
  }
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
  numeric = false
}

resource "aws_opensearchserverless_collection" "main" {
  name = var.collection_name
  type = "SEARCH"

  depends_on = [aws_opensearchserverless_security_policy.encryption]

  tags = var.tags
}

resource "aws_opensearchserverless_security_policy" "encryption" {
  name = "${var.collection_name}-encryption"
  type = "encryption"

  policy = jsonencode({
    Rules = [
      {
        ResourceType = "collection"
        Resource     = ["collection/${var.collection_name}"]
      }
    ]
    AWSOwnedKey = true
  })
}

resource "aws_opensearchserverless_security_policy" "network" {
  name = "${var.collection_name}-network"
  type = "network"

  policy = jsonencode([
    {
      Rules = [
        {
          ResourceType = "collection"
          Resource     = ["collection/${var.collection_name}"]
        },
        {
          ResourceType = "dashboard"
          Resource     = ["collection/${var.collection_name}"]
        }
      ]
      AllowFromPublic = true
    }
  ])
}

resource "aws_opensearchserverless_access_policy" "data" {
  name = "${var.collection_name}-data"
  type = "data"

  depends_on = [aws_opensearchserverless_collection.main]

  policy = jsonencode([
    {
      Rules = [
        {
          ResourceType = "collection"
          Resource     = ["collection/${var.collection_name}"]
          Permission = [
            "aoss:CreateCollectionItems",
            "aoss:DeleteCollectionItems",
            "aoss:UpdateCollectionItems",
            "aoss:DescribeCollectionItems"
          ]
        },
        {
          ResourceType = "index"
          Resource     = ["index/${var.collection_name}/*"]
          Permission = [
            "aoss:CreateIndex",
            "aoss:DeleteIndex",
            "aoss:UpdateIndex",
            "aoss:DescribeIndex",
            "aoss:ReadDocument",
            "aoss:WriteDocument"
          ]
        },
        {
          ResourceType = "dashboard"
          Resource     = ["collection/${var.collection_name}"]
          Permission = [
            "aoss:CreateCollectionItems",
            "aoss:DeleteCollectionItems",
            "aoss:UpdateCollectionItems",
            "aoss:DescribeCollectionItems"
          ]
        }
      ]
      Principal = concat(
        [aws_iam_role.firehose_role.arn],
        var.cognito_user_pool_arn != null ? [var.cognito_user_pool_arn] : [],
        var.iam_principals
      )
    }
  ])
}

resource "aws_iam_role" "firehose_role" {
  name = "firehose-opensearch-${random_string.random.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "firehose_opensearch" {
  name = "firehose-opensearch-${random_string.random.result}"
  role = aws_iam_role.firehose_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "aoss:APIAccessAll"
        ]
        Resource = aws_opensearchserverless_collection.main.arn
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/kinesisfirehose/*"
      }
    ]
  })
}

resource "aws_kinesis_firehose_delivery_stream" "opensearch" {
  name        = "${var.collection_name}-firehose-${random_string.random.result}"
  destination = "opensearch"

  opensearch_configuration {
    domain_arn = aws_opensearchserverless_collection.main.arn
    role_arn   = aws_iam_role.firehose_role.arn
    index_name = var.index_name
    type_name  = "_doc"
    
    processing_configuration {
      enabled = var.enable_data_processing
      
      processors {
        type = "Lambda"
        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = var.lambda_processor_arn
        }
      }
    }
    
    retry_duration = var.retry_duration
    
    s3_configuration {
      role_arn   = aws_iam_role.firehose_role.arn
      bucket_arn = var.s3_backup_bucket_arn
      prefix     = var.s3_backup_prefix
      
      buffering_size     = var.s3_buffering_size
      buffering_interval = var.s3_buffering_interval
    }
  }

  tags = var.tags
}

resource "aws_cloudwatch_log_subscription_filter" "opensearch" {
  count = length(var.log_group_names)
  
  name            = "${var.collection_name}-subscription-${count.index}"
  log_group_name  = var.log_group_names[count.index]
  filter_pattern  = var.filter_pattern
  destination_arn = aws_kinesis_firehose_delivery_stream.opensearch.arn
  role_arn       = aws_iam_role.firehose_role.arn
}

resource "aws_iam_role" "cloudwatch_logs_role" {
  name = "cloudwatch-logs-firehose-${random_string.random.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "logs.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "cloudwatch_logs_firehose" {
  name = "cloudwatch-logs-firehose-${random_string.random.result}"
  role = aws_iam_role.cloudwatch_logs_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "firehose:PutRecord",
          "firehose:PutRecordBatch"
        ]
        Resource = aws_kinesis_firehose_delivery_stream.opensearch.arn
      }
    ]
  })
}
