# Create a service account
resource "google_service_account" "my_service_infra_service_account" {
  account_id   = var.account_id
  display_name = var.display_name
}

# Create a custom role for the service account
resource "google_project_iam_custom_role" "my_service_infra_admin" {
  role_id     = var.role_id
  title       = var.role_title
  description = var.role_description
  permissions = var.role_permissions_list
}

# Bind the role to teh Service account
resource "google_project_iam_binding" "my_service_infra_binding" {
  role = "projects/${var.project_id}/roles/${google_project_iam_custom_role.my_service_infra_admin.role_id}"
  members = [
    "serviceAccount:${google_service_account.my_service_infra_service_account.email}",
  ]
}