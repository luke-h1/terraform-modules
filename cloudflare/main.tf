terraform {
  backend "s3" {
    bucket  = "lho-cloudflare-production-tf-state"
    encrypt = true
    key     = "vpc/terraform.tfstate"
  }
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
