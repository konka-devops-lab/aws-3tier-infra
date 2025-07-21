output "role_id" {
  value       = aws_iam_role.this.id
  description = "The ID of the IAM role created"
}
output "role_arn" {
  value       = aws_iam_role.this.arn
  description = "The ARN of the IAM role created"
}

output "instance_profile_id" {
  value       = aws_iam_instance_profile.backend_profile.id
  description = "The ID of the IAM instance profile created"
}
output "instance_profile_arn" {
  value       = aws_iam_instance_profile.backend_profile.arn
  description = "The ARN of the IAM instance profile created"
}