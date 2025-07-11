resource "aws_secretsmanager_secret" "example" {
  name = "${var.environment}/${var.project_name}/${var.secret_name}"
}
resource "aws_secretsmanager_secret_version" "example_version" {
  secret_id     = aws_secretsmanager_secret.example.id
  secret_string = jsonencode(var.secret_values)
}

variable "environment" {
  description = "The environment for the resources (e.g., dev, staging, prod)"
  type        = string
}
variable "project_name" {
  description = "The name of the project"
  type        = string
}
variable "secret_name" {
  description = "The name of the secret to be created in Secrets Manager"
  type        = string
}
variable "secret_values" {
  description = "A map of secret values to be stored in Secrets Manager"
  type        = map(string)
  default     = {}
}

output "secret_arn" {
  value = aws_secretsmanager_secret.example.arn
}

output "secret_name" {
  value = aws_secretsmanager_secret.example.name
}