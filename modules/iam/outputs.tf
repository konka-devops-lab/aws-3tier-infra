output "role_id" {
  value       = aws_iam_role.this.id
  description = "The ID of the IAM role created"
}
output "arn" {
  value       = aws_iam_role.this.arn
  description = "The ARN of the IAM role created"
}