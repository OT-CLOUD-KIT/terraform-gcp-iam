output "iam_roles_assigned" {
  value = module.iam_mngmnt.iam_roles_assigned
}

output "custom_roles_created" {
  value = module.iam_mngmnt.custom_roles_created
}

output "service_accounts_created" {
  value = module.service_account_mngmnt.service_accounts_created
}

