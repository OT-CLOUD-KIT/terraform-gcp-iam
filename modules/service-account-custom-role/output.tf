output "Role" {
  value       = google_project_iam_custom_role.my_service_infra_admin.role_id
  description = "ID of the SA role."
}

output "Permissions" {
  value       = google_project_iam_custom_role.my_service_infra_admin.permissions
  description = "Permissions assigned."
}

output "Project" {
  value       = google_project_iam_custom_role.my_service_infra_admin.project
  description = "Permissions assigned."
}

output "ServiceAccount" {
  value       = google_service_account.my_service_infra_service_account.email
  description = "Service ACcount email ID"
}