resource "google_project_iam_member" "iam_roles" {
  for_each = var.create_iam_roles ? merge([
    for role, members in var.iam_roles : {
      for m in members :
      "${role}-${index(members, m)}" => { role = role, member = m }
    }
  ]...) : {}

  project = var.project_id
  role    = each.value.role
  member  = each.value.member
}


resource "google_project_iam_custom_role" "custom" {
  for_each    = var.create_custom_roles ? var.custom_roles : {}
  project     = var.project_id
  role_id     = each.value.role_id
  title       = each.value.title
  description = each.value.description
  permissions = each.value.permissions
}

resource "google_project_iam_member" "assign_custom_roles" {
  for_each   = var.create_custom_roles ? var.custom_roles : {}
  project    = var.project_id
  role       = "projects/${var.project_id}/roles/${each.value.role_id}"
  member     = each.value.member
  depends_on = [google_project_iam_custom_role.custom] # Ensure the role exists first
}

