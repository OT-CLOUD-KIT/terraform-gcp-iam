variable "project_id" {
  type    = string
  default = "nice-unison-356709"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "role_id" {
  type    = string
  default = "customRoleId"
}

variable "role_title" {
  type    = string
  default = "Custom GCP Role"
}

variable "role_description" {
  type    = string
  default = "This is a custom role"
}

variable "role_permissions_list" {
  type = list(string)
  default = ["compute.instances.create",
  "compute.instances.delete"]
}