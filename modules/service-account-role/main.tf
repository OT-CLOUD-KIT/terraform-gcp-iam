provider "google" {
  credentials = file("credentials.json")
  project = var.project_id
  region  = "us-central1"
  zone    = "us-central1-a"
}

# Assign a custom role to a service account. Create a custom role to assign to the service account

resource "google_project_iam_custom_role" "my_service_infra_admin" {
  role_id     = var.role_id
  title       = "my_service_infra_admin"
  description = "Infrastructure Administrator Custom Role"
  permissions = var.role_permissions_list
}

resource "google_project_iam_binding" "my_service_infra_binding" {
  role = "projects/${var.project_id}/roles/${google_project_iam_custom_role.my_service_infra_admin.role_id}"
  members = var.member
}