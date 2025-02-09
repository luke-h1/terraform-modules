output "lho_summary" {
  value = [
    module.lho.summary
  ]
}

output "tf_user_summary" {
  value = [
    module.tf_user.summary
  ]
}

output "links" {
  value = {
    aws_console_sign_in    = "https://${aws_organizations_account.users.id}.signin.aws.amazon.com/console/"
    switch_role_staging    = "https://signin.aws.amazon.com/switchrole?account=${aws_organizations_account.staging.id}&roleName=${urlencode(module.dev_role_staging.role_name)}&displayName=${urlencode("Developer@staging")}"
    switch_role_production = "https://signin.aws.amazon.com/switchrole?account=${aws_organizations_account.production.id}&roleName=${urlencode(module.dev_role_production.role_name)}&displayName=${urlencode("Developer@production")}"
    switch_role_readonly   = "https://signin.aws.amazon.com/switchrole?account=${aws_organizations_account.users.id}&roleName=Readonly&displayName=Readonly"
    switch_role_admin      = "https://signin.aws.amazon.com/switchrole?account=${aws_organizations_account.users.id}&roleName=Admin&displayName=Admin"
    switch_role_superadmin = "https://signin.aws.amazon.com/switchrole?account=${aws_organizations_account.users.id}&roleName=Superadmin&displayName=Superadmin"
  }
}
