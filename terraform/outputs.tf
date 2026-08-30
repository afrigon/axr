output "bucket" {
  description = "Name of the S3 bucket holding the repository content"
  value       = aws_s3_bucket.mirror.bucket
}

output "distribution_id" {
  description = "CloudFront distribution ID serving the repository"
  value       = aws_cloudfront_distribution.mirror.id
}
