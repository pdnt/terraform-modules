
# Create logging s3 bucket
resource "aws_s3_bucket" "log_bucket" {
  bucket = "${var.project_name}-${var.env_file_bucket_name}-logging"
}

# Enable logging
resource "aws_s3_bucket_logging" "env_file_bucket" {
  bucket = "${var.project_name}-${var.env_file_bucket_name}"

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}