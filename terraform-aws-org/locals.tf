locals {
  account_name = {
    users      = "lho-aws-users"
    staging    = "lho-aws-staging"
    production = "lho-aws-production"
  }

  # Some email providers offer sub-addressing, with a tag after the + (plus) sign, so you can have infinite amount of addresses.
  account_owner_email = {
    users      = var.users_email
    staging    = var.staging_email
    production = var.production_email
  }

  terraform_state_bucket_name = {
    staging    = "lhowsam-aws-terraform-tfstate-staging"
    production = "lhowsam-aws-terraform-tfstate-production"
  }
}
