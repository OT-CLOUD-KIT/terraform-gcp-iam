# resource "google_service_account" "service_accounts" {
#   for_each     = var.service_accounts
#   account_id   = each.key
#   display_name = each.value.display_name
# }

# resource "google_project_iam_member" "sa_roles" {
#   for_each = var.service_accounts
#   project  = var.project_id
#   role     = each.value.role
#   member   = "serviceAccount:${google_service_account.service_accounts[each.key].email}"
# }

resource "google_service_account" "service_accounts" {
  for_each     = var.service_accounts
  account_id   = each.key
  display_name = each.value.display_name
}

resource "google_project_iam_member" "sa_roles" {
  for_each = {
    for k, v in var.service_accounts :
    k => v if startswith(v.role, "roles/") || (var.use_custom_roles && !startswith(v.role, "roles/"))
  }

  project = var.project_id

  role = (
    startswith(each.value.role, "roles/")
    ? each.value.role
    : var.use_custom_roles
    ? "projects/${var.project_id}/roles/${each.value.role}"
    : null
  )

  member = "serviceAccount:${google_service_account.service_accounts[each.key].email}"
}





