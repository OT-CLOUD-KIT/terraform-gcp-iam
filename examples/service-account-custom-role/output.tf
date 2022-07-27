output "Role" {
  value       = module.gcp_service_account_custom_role.Role
  description = "Details of the project that was assigned role"
}

output "Permissions" {
  value       = module.gcp_service_account_custom_role.Permissions
  description = "Details of the project that was assigned role"
}

output "Project" {
  value       = module.gcp_service_account_custom_role.Project
  description = "Details of the project that was assigned role"
}

output "ServiceAccount" {
  value = module.gcp_service_account_custom_role.ServiceAccount
}