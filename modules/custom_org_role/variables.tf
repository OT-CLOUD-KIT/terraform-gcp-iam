variable "project_id" {
  type    = string
  default = "nice-unison-356709"
}

variable "org_id" {
  type    = string
  default = "OrgId"
}

variable "role_id" {
  type    = string
  default = "customRole"
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
  type = list(string)
  default = ["compute.instances.create",
  "compute.instances.delete"]
}

variable "member" {
  type    = string
  default = "user:nilamk.negi@gmail.com"
}