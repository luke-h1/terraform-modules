module "lho" {
  source  = "./modules/user"
  name    = "lho-user"
  pgp_key = var.lho_pgp_key

  groups = [
    aws_iam_group.self_managing.name,
    module.dev_group_staging.group_name,
    module.dev_group_production.group_name,
    # aws_iam_group.readonly.name,
    # aws_iam_group.admin.name,
    # aws_iam_group.superadmin.name
  ]

  providers = {
    aws = aws.users
  }
}

module "tf_user" {
  source  = "./modules/user"
  name    = "tf-user"
  pgp_key = var.ci_user_pgp_key

  groups = [
    aws_iam_group.self_managing.name,
    module.dev_group_staging.group_name,
    module.dev_group_production.group_name,
    # aws_iam_group.readonly.name,
    # aws_iam_group.admin.name,
    # aws_iam_group.superadmin.name
  ]

  providers = {
    aws = aws.users
  }
}
