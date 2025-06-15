variable "environment" {
  description = "The environment for the load balancer"
  type        = string
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "lb_name" {
  description = "The name of the load balancer"
  type        = string
}
variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}
variable "choose_internal_external" {
  description = "Choose whether the load balancer is internal or external"
  type        = bool
}
variable "load_balancer_type" {
  description = "The type of load balancer (application, network, or gateway)"
  type        = string
}
variable "enable_zonal_shift" {
  description = "Enable zonal shift for the load balancer"
  type        = bool
}
variable "security_groups" {
  description = "List of security group IDs to associate with the load balancer"
  type        = list(string)
}
variable "subnets" {
  description = "List of subnet IDs to associate with the load balancer"
  type        = list(string)
}
variable "enable_deletion_protection" {
  description = "Enable deletion protection for the load balancer"
  type        = bool
  default     = false
}

variable "zone_id" {
  description = "The Route 53 zone ID for the DNS record"
  type        = string
}

variable "alb_record_name" {
  description = "The DNS record name for the load balancer"
  type        = string
}

# variable "bucket_name" {
#   description = "The name of the S3 bucket for access logs"
#   type        = string
# }
# variable "prefix" {
#   description = "The prefix for the access logs in the S3 bucket"
#   type        = string
# }
# variable "logs_enabled" {
#   description = "Enable access logs for the load balancer"
#   type        = bool
# }