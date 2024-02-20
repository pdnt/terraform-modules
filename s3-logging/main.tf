# Create key for s3 bucket
#I ignore the tfsec alert about disabled KMS key rotation because the deletion window of such key is 10 days
resource "aws_kms_key" "mykey" { #tfsec:ignore:aws-kms-auto-rotate-keys
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10 
}

# Create logging s3 bucket
# Ignore logging for the logging bucket
resource "aws_s3_bucket" "log_bucket" { #tfsec:ignore:aws-s3-enable-bucket-logging
  bucket = "${var.project_name}-${var.env_file_bucket_name}-logging"
}

# Enable logging
resource "aws_s3_bucket_logging" "env_file_bucket" {
  bucket = "${var.project_name}-${var.env_file_bucket_name}"

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}

# Encrypt s3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "aws_s3_encryption" {
  bucket = aws_s3_bucket.log_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# Enable blocking any PUT calls with a public ACL
resource "aws_s3_bucket_public_access_block" "aws_s3_block_PUT_calls" {
  bucket = aws_s3_bucket.log_bucket.id
  block_public_acls = var.block_public_acls
  block_public_policy = var.block_public_policy
  ignore_public_acls = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

# Enable versioning to protect against accidental/malicious removal or modification
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.log_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}