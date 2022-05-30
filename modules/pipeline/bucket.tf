resource "aws_s3_bucket" "bucket" {
  bucket = format("%s-pipeline", var.cluster_name)
  tags = {
    "Name" = var.cluster_name
  }
}
resource "aws_s3_bucket_acl" "s3Acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}