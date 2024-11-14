resource "aws_security_group" "rds_db" {
  name   = "rds-${var.env}-${var.name}"
  vpc_id = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "rds_db_replica" {
  name   = "rds-${var.env}-${var.name}-replica"
  vpc_id = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "rds_db_inbound_cidrs" {
  count             = length(var.allow_cidrs) != 0 ? 1 : 0
  type              = "ingress"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  cidr_blocks       = var.allow_cidrs
  security_group_id = aws_security_group.rds_db.id
  description       = "From CIDR ${join(", ", var.allow_cidrs)}"
}

resource "aws_security_group_rule" "rds_db_inbound_from_sg" {
  for_each                 = { for security_group_id in var.allow_security_group_ids : security_group_id.name => security_group_id }
  type                     = "ingress"
  from_port                = var.port
  to_port                  = var.port
  protocol                 = "tcp"
  source_security_group_id = each.value.security_group_id
  security_group_id        = aws_security_group.rds_db.id
  description              = try(each.value.description, "From ${each.value.security_group_id}")
}

resource "aws_security_group_rule" "egress_rule" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.rds_db.id
  cidr_blocks       = ["0.0.0.0/0"]
}

##SG for Replica

resource "aws_security_group_rule" "rds_db_inbound_cidrs_replica" {
  count             = length(var.allow_cidrs_replica) != 0 ? 1 : 0
  type              = "ingress"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  cidr_blocks       = var.allow_cidrs_replica
  security_group_id = aws_security_group.rds_db_replica.id
  description       = "From CIDR ${join(", ", var.allow_cidrs_replica)}"
}

resource "aws_security_group_rule" "rds_db_inbound_from_sg_replica" {
  for_each                 = { for security_group_id in var.allow_security_group_ids_replica : security_group_id.name => security_group_id }
  type                     = "ingress"
  from_port                = var.port
  to_port                  = var.port
  protocol                 = "tcp"
  source_security_group_id = each.value.security_group_id
  security_group_id        = aws_security_group.rds_db_replica.id
  description              = try(each.value.description, "From ${each.value.security_group_id}")
}

resource "aws_security_group_rule" "egress_rule_replica" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.rds_db_replica.id
  cidr_blocks       = ["0.0.0.0/0"]
}