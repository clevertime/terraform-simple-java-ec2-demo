data "aws_caller_identity" "this" {}
data "aws_region" "this" {}

locals {
  account_id         = data.aws_caller_identity.this.account_id
  region             = data.aws_region.this.name
  tags               = var.tags
  is_t_instance_type = replace(var.instance_type, "/^t(2|3|3a){1}\\..*$/", "1") == "1" ? true : false
  name_tag           = { "Name" = var.name }

  virtualization = {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  ami_filters = {
    rhel_7 = { owners : ["309956199498"], filters : { name : { name : "name", values : ["RHEL-7.?*GA*"] }, type : local.virtualization } }
    rhel_8 = { owners : ["309956199498"], filters : { name : { name : "name", values : ["RHEL-8.*_HVM-*"] }, type : local.virtualization } }
  }

  archive_keys = {
    "java8-rhel8" = aws_s3_bucket_object.java8_rhel8.*.id
  }
  archive_key = local.archive_keys[trimsuffix(var.userdata_file, ".sh")][0]

  userdata = templatefile("${path.module}/files/${var.userdata_file}", {
    region = local.region
    bucket = aws_s3_bucket.code.id
    key    = local.archive_key
  })
}


data "aws_ami" "this" {
  most_recent = true
  owners      = local.ami_filters[var.ami].owners

  dynamic "filter" {
    for_each = local.ami_filters[var.ami].filters
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}
