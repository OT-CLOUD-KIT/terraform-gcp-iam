output "role_id" {
  value       = module.gcp_iam_custom_org_role.custom_org_role
  description = "ID of the custom role created."
}