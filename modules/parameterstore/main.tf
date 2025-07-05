# Resource Block
resource "aws_ssm_parameter" "foo" {
  for_each = var.parameters
  name  = "/${var.environment}/${var.project_name}/${each.key}"
  type  = "String"
  value = each.value
    tags = merge({
    Name = "${var.environment}-${var.project_name}-${each.key}"
    },
    var.common_tags
    )
}

# Variables
variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}
variable "parameters" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}
variable "environment" {
  description = "The environment for the resources (e.g., dev, staging, prod)"
  type        = string
}
variable "project_name" {
  description = "The name of the project"
  type        = string  
}

# Outputs
output "arns" {
  description = "The ARNs of the created SSM parameters"
  value       = { for k, v in aws_ssm_parameter.foo : k => v.arn }
}