variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "service_accounts" {
  description = "Map of service accounts and their assigned roles"
  type = map(object({
    display_name = string
    role         = string # Either a predefined IAM role OR a custom role
  }))
  default = {}
}

variable "use_custom_roles" {
  description = "Set to true to assign custom roles instead of default roles"
  type        = bool
  default     = false
}


