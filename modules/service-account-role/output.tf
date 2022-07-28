output "role" {
  value       = google_project_iam_binding.my_service_infra_binding.role
  description = "ID of the SA role."
}

output "service-account" {
  value       = google_service_account.my_service_infra_service_account.email
  description = "Permissions assigned."
}
