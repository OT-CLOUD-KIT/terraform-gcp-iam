variable "project_id" {
  type        = string
  description = "Value for Project ID"
}

variable "role" {
  type        = string
  description = "Role permission to be assigned. e.g roles/appengine.appAdmin"
}

variable "member" {
  type        = string
  description = "Member id e.g user:nilamk,negi@gmail.com"
}