output "iam_roles_assigned" {
  description = "List of default IAM roles assigned"
  value       = keys(google_project_iam_member.iam_roles)
}

output "custom_roles_created" {
  description = "List of custom IAM roles created"
  value       = keys(google_project_iam_custom_role.custom)
}

