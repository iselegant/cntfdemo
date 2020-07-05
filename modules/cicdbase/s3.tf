resource "aws_s3_bucket" "artifact" {
  bucket = "${var.resource_id}-artifact-${var.aws_account_id}"
  acl    = "private"
  lifecycle_rule {
    enabled = true
    expiration {
      days = "180"
    }
  }
}