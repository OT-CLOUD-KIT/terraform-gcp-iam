provider "google" {
  credentials = file("credentials.json")
  project     = var.project_id
  region      = var.region
}

module "gcp_service_account" {
  source     = "../../modules/service-account-role"
  project_id = var.project_id
  role_id = var.role_id
  role_permissions_list = var.role_permissions_list
  member = var.member
}