resource "aws_s3_bucket" "code" {
  bucket = join("-", [var.name, "artifacts", local.account_id])

  server_side_encryption_configuration {
    rule {
      bucket_key_enabled = true
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }
}


data "archive_file" "java8_rhel8" {
  count       = trimsuffix(var.userdata_file, ".sh") == "java8-rhel8" ? 1 : 0
  type        = "zip"
  source_dir  = "${path.module}/code/java8-rhel8/"
  output_path = "${path.module}/code/java8-rhel8.zip"
}

resource "aws_s3_bucket_object" "java8_rhel8" {
  count  = trimsuffix(var.userdata_file, ".sh") == "java8-rhel8" ? 1 : 0
  bucket = aws_s3_bucket.code.id
  key    = "java8-rhel8.zip"
  source = data.archive_file.java8_rhel8[0].output_path
  etag   = filemd5(data.archive_file.java8_rhel8[0].output_path)
}
