resource "aws_s3_bucket" "artifact" {
  bucket = "${var.resource_id}-artifacts-${var.aws_account_id}"
  acl    = "private"
  lifecycle_rule {
    enabled = true
    expiration {
      days = "180"
    }
  }
}

output "s3_artifact_bucket" {
  value = aws_s3_bucket.artifact.bucket
}
