# export the s3 bucket name
output "env_file_bucket_name" {
  value = var.env_file_bucket_name
}

# export the environment file name
output "env_file_name" {
  value = var.env_file_name
}

# export the s3 bucket id
output "env_file_bucket_id" {
  value = var.env_file_bucket.id
}