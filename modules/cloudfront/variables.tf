variable "domain_name" {
  type = string
}

variable "origin_id" {
  type = string
}

variable "aliases" {
  type    = list(string)
  default = []
}

variable "enabled" {
  type    = bool
  default = true
}

variable "acm_certificate_arn" {
  
}
variable "default_root_object" {
  type = string
  default = ""
}

variable "invalidation_paths" {}