variable "project_id" {
  type    = string
}

variable "role_id" {
  type    = string
}

variable "role_title" {
  type    = string
} 

variable "role_description" {
  type    = string
}
variable "role_permissions_list" {
  type    = list(string)
}

variable "account_id" {
  type    = string
}

variable "display_name" {
  type    = string
}