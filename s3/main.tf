# create an s3 bucket 
resource "aws_s3_bucket" "env_file_bucket" {
  bucket = "${var.project_name}-${var.env_file_bucket_name}-unencrypted"

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = "${var.project_name}-${var.env_file_bucket_name}"

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# upload the environment file from local computer into the s3 bucket
resource "aws_s3_object" "upload_env_file" {
  bucket = aws_s3_bucket.env_file_bucket.id
  key    = var.env_file_name
  source = "./${var.env_file_name}"
}