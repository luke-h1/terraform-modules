variable "name" {
  type        = string
  description = "The name to give the IAM user"
}

variable "pgp_key" {
  type        = string
  description = "the PGP key to decrypt the IAM information"
}

variable "groups" {
  type = list(string)
}
