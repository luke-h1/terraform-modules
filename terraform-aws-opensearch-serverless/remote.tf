terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-lho"
    key    = "opensearch-serverless/terraform.tfstate"
    region = "eu-west-2"
  }
}
