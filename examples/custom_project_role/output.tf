output "role_id" {
  value       = module.gcp_iam_custom_project_role.custom_project_role
  description = "ID of the custom role created."
}