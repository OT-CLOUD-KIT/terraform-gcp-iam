output "role" {
  value       = module.gcp_service_account.role
  description = "Details of the project that was assigned role"
}

output "service-account" {
  value       = module.gcp_service_account.service-account
  description = "Service ACcount details"
}
