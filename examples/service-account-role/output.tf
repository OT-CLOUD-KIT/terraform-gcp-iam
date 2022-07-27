output "Role" {
  value       = module.gcp_service_account.Role
  description = "Details of the project that was assigned role"
}

output "ServiceAccount" {
  value       = module.gcp_service_account.ServiceAccount
  description = "Service ACcount details"
}
