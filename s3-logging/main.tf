
# Create logging s3 bucket
resource "aws_s3_bucket" "log_bucket" {
  bucket = "${var.project_name}-${var.env_file_bucket_name}-logging"
}
# Provide ACL to logging bucket
resource "aws_s3_bucket_acl" "log_bucket_acl" {
  bucket = aws_s3_bucket.log_bucket.id
  acl    = "log-delivery-write"
}

# Enable logging
resource "aws_s3_bucket_logging" "env_file_bucket" {
  bucket = aws_s3_bucket.env_file_bucket.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}