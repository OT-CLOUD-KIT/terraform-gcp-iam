variable "project_id" {
  type    = string
  default = "nice-unison-356709"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "role" {
  type = string
  default = "roles/compute.networkAdmin"
}

variable "member" {
  type    = string
  default = "user:nilamk.negi@gmail.com"
  # testadmin@nice-unison-356709.iam.gserviceaccount.com
}