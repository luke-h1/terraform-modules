variable "users_email" {
  type        = string
  description = "the users account owner email address"
}

variable "staging_email" {
  type        = string
  description = "the staging account owner email address"
}

variable "production_email" {
  type        = string
  description = "the production account owner email address"
}

variable "lho_pgp_key" {
  type        = string
  description = "PGP key for lhowsam user"
}

variable "ci_user_pgp_key" {
  type        = string
  description = "PGP key for CI user"
}
