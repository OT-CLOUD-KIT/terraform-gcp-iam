variable "project_id" {
  type        = string
  description = "Value for Project ID"
}

variable "org_id" {
  type        = string
  description = "Value for Organization ID"
}

variable "role_id" {
  type        = string
  description = "Value for Role ID"
}

variable "role_title" {
  type    = string
  default = "Title for custom role"
}

variable "role_description" {
  type    = string
  default = "Description for custom role"
}

variable "role_permissions_list" {
  type        = list(string)
  description = "List of permissions in the format [ , ]"
}

variable "member" {
  type        = string
  description = "User or service account, e.g user:nilamk,negi@gmail.com"
}