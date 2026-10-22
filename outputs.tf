output "project_binding_ids" {
  description = "Project IAM member resource IDs keyed by binding and principal."
  value       = { for key, binding in google_project_iam_member.project : key => binding.id }
}

output "group_binding_ids" {
  description = "Group IAM member resource IDs keyed by binding and group."
  value       = { for key, binding in google_project_iam_member.group : key => binding.id }
}

output "expiring_binding_ids" {
  description = "Temporary IAM member resource IDs keyed by binding and principal."
  value       = { for key, binding in google_project_iam_member.expiring : key => binding.id }
}

output "conditional_binding_ids" {
  description = "Conditional IAM member resource IDs keyed by binding and principal."
  value       = { for key, binding in google_project_iam_member.conditional : key => binding.id }
}

output "custom_role_names" {
  description = "Fully qualified names of custom roles."
  value       = { for key, role in google_project_iam_custom_role.custom : key => role.name }
}

output "service_account_emails" {
  description = "Email addresses of service accounts created by the module."
  value       = { for key, account in google_service_account.managed : key => account.email }
}

output "pam_entitlement_names" {
  description = "Fully qualified names of Privileged Access Manager entitlements."
  value       = { for key, entitlement in google_privileged_access_manager_entitlement.this : key => entitlement.name }
}
