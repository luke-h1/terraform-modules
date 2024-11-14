# terraform-aws-log-exporter

This module creates a lambda function that exports log groups on the AWS account and region deployed(default every 4 hours).

It will only export each log group if it has the tag `ExportS3=true`, if the last export was more than 24 hours ago it creates an export task to the `S3_BUCKET` defined saving the current timestamp in a SSM parameter.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.0 |
| aws | >= 4.61.0 |
| random | >= 3.4.0 |

## Providers

| Name | Version |
|------|---------|
| archive | n/a |
| aws | >= 4.61.0 |
| random | >= 3.4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloudwatch\_logs\_export\_bucket | Bucket to export logs | `string` | `""` | no |
| runtime | Runtime version of the lambda function | `string` | `"python3.10"` | no |

## Outputs

No outputs
