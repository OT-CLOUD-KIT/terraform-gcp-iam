provider "google" {
  credentials = file("testadmin.json")
  project     = var.project_id
  region      = var.region
}

module "gcp_iam_assign_project_role" {
  source = "../../modules/iam_project"
  #   permissions = var.role_permissions_list
}