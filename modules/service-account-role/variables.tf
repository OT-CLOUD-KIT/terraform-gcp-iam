variable "project_id" {
  type = string
  description = "Project ID value"
}

variable "role_id" {
  type = string
  description = "Role Id"
}

variable "role_permissions_list" {
  type = list(string)
  description = "List of permissions"
}

variable "member" {
  type    = list(string)
  description = "service account email ID e.g serviceAccount:email"
}