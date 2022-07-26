provider "google" {
  credentials = file("testadmin.json")
  project     = var.project_id
  region      = var.region
}

module "gcp_iam_assign_project_role" {
  source = "../../modules/iam_project"
  role = var.role
  project_id = var.project_id
  member = var.member
  #   permissions = var.role_permissions_list
}