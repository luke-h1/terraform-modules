resource "aws_iam_user" "this" {
  name = var.name
}

resource "aws_iam_user_login_profile" "this" {
  user                    = aws_iam_user.this.name
  password_length         = 12
  password_reset_required = true
  pgp_key                 = var.pgp_key
}

resource "aws_iam_access_key" "this" {
  user    = aws_iam_user.this.name
  pgp_key = var.pgp_key
}

resource "aws_iam_user_group_membership" "this" {
  user   = aws_iam_user.this.name
  groups = var.groups
}
