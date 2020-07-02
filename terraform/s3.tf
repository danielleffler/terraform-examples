resource "aws_s3_bucket" "argo-workflow-artifacts" {
  bucket = "codezen-argo-workflow-artifacts"
  acl    = "private"
  force_destroy = true
}