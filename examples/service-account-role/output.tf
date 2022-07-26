output "Role" {
  value       = module.gcp_service_account.Role
  description = "Details of the project that was assigned role"
}

output "Permissions" {
  value       = module.gcp_service_account.Permissions
  description = "Details of the project that was assigned role"
}

output "Project" {
  value       = module.gcp_service_account.Project
  description = "Details of the project that was assigned role"
}