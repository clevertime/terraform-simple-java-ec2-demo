resource "aws_instance" "this" {
  ami                    = data.aws_ami.this.id
  instance_type          = var.instance_type
  user_data              = local.userdata
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  monitoring             = var.monitoring
  get_password_data      = var.get_password_data
  vpc_security_group_ids = concat(var.vpc_security_group_ids, aws_security_group.this.*.id)
  iam_instance_profile   = aws_iam_instance_profile.this.id

  associate_public_ip_address = var.associate_public_ip_address
  private_ip                  = var.private_ip
  ipv6_address_count          = var.ipv6_address_count
  ipv6_addresses              = var.ipv6_addresses

  ebs_optimized = var.ebs_optimized

  dynamic "root_block_device" {
    for_each = var.root_block_device
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(root_block_device.value, "encrypted", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
      tags                  = lookup(root_block_device.value, "tags", null)
    }
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device
    content {
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
    }
  }

  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_device
    content {
      device_name  = ephemeral_block_device.value.device_name
      no_device    = lookup(ephemeral_block_device.value, "no_device", null)
      virtual_name = lookup(ephemeral_block_device.value, "virtual_name", null)
    }
  }

  dynamic "metadata_options" {
    for_each = length(keys(var.metadata_options)) == 0 ? [] : [var.metadata_options]
    content {
      http_endpoint               = lookup(metadata_options.value, "http_endpoint", "enabled")
      http_tokens                 = lookup(metadata_options.value, "http_tokens", "optional")
      http_put_response_hop_limit = lookup(metadata_options.value, "http_put_response_hop_limit", "1")
    }
  }

  dynamic "network_interface" {
    for_each = var.network_interface
    content {
      device_index          = network_interface.value.device_index
      network_interface_id  = lookup(network_interface.value, "network_interface_id", null)
      delete_on_termination = lookup(network_interface.value, "delete_on_termination", false)
    }
  }

  source_dest_check                    = length(var.network_interface) > 0 ? null : var.source_dest_check
  disable_api_termination              = var.disable_api_termination
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  placement_group                      = var.placement_group
  tenancy                              = var.tenancy

  tags = merge(local.tags, local.name_tag)

  volume_tags = var.enable_volume_tags ? merge(var.volume_tags, local.tags, local.name_tag) : null

  credit_specification {
    cpu_credits = local.is_t_instance_type ? var.cpu_credits : null
  }
}
