resource "aws_security_group" "this" {
  count = var.vpc_id != null ? 1 : 0

  name        = var.name
  description = var.name
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.security_group_cidr_ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      description = ingress.value.description
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "ingress" {
    for_each = var.security_group_sg_ingress_rules
    content {
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      description     = ingress.value.description
      protocol        = ingress.value.protocol
      security_groups = ingress.value.security_groups
    }
  }

  dynamic "egress" {
    for_each = var.security_group_egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = merge(local.tags, local.name_tag)
}
