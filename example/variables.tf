variable "region" {
  description = "The default project ID where resources will be created"
  type        = string
}

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "create_iam_roles" {
  description = "Set to true to create default IAM roles"
  type        = bool
  default     = false
}

variable "iam_roles" {
  description = "Map of default IAM roles and members"
  type        = map(list(string))
  default     = {}
}

variable "create_custom_roles" {
  description = "Set to true to create custom IAM roles"
  type        = bool
  default     = false
}

variable "custom_roles" {
  description = "Map of custom roles with permissions and assignees"
  type = map(object({
    role_id     = string
    title       = string
    description = string
    permissions = list(string)
    member      = string
  }))
  default = {}
}

variable "use_custom_roles" {
  description = "Set to true to assign custom roles to service accounts"
  type        = bool
  default     = false
}

variable "service_accounts" {
  description = "Map of service accounts and their assigned roles"
  type = map(object({
    display_name = string
    role         = string # Can be a predefined IAM role or a custom role
  }))
  default = {}
}
