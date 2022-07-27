output "role" {
  value       = google_project_iam_custom_role.my_service_infra_admin.role_id
  description = "ID of the SA role."
}

output "permissions" {
  value       = google_project_iam_custom_role.my_service_infra_admin.permissions
  description = "Permissions assigned."
}

output "project" {
  value       = google_project_iam_custom_role.my_service_infra_admin.project
  description = "Permissions assigned."
}

output "service-account" {
  value       = google_service_account.my_service_infra_service_account.email
  description = "Service ACcount email ID"
}
