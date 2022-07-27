
# Create a service account
resource "google_service_account" "my_service_infra_service_account" {
  account_id   = var.account_id
  display_name = var.display_name
}

#Assign role to service account
resource "google_project_iam_binding" "my_service_infra_binding" {
  role = var.role_permissions
  members = [
    "serviceAccount:${google_service_account.my_service_infra_service_account.email}",
  ]
}