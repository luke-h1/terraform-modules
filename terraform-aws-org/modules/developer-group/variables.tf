variable "group_name" {
  description = "The name to give the group"
  type        = string
}

variable "assume_role_arns" {
  description = "A list of role ARNs to attach to the group"
  type        = list(string)
}