output "role" {
  value       = module.gcp_service_account_custom_role.role
  description = "Details of the project that was assigned role"
}

output "permissions" {
  value       = module.gcp_service_account_custom_role.permissions
  description = "Details of the project that was assigned role"
}

output "project" {
  value       = module.gcp_service_account_custom_role.project
  description = "Details of the project that was assigned role"
}

output "service-account" {
  value = module.gcp_service_account_custom_role.service-account
}