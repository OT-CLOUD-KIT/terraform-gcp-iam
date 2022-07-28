variable "project_id" {
  type    = string
  description = "Value for Project ID"
}

variable "role_id" {
  type    = string
  description  = "Value for Role ID"
}

variable "role_title" {
  type    = string
  default = "Title for the custom role you wish to create"
}

variable "role_description" {
  type    = string
  default = "Description for the custom role"
}

variable "role_permissions_list" {
  type = list(string)
  description = "List of permissions to be assigned to the custom role"
}

variable "member" {
  type    = string
  description = "User or service account, e.g user:nilamk,negi@gmail.com"
}
