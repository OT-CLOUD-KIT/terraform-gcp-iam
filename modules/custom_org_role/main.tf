# Create a custom iam role at organization level
resource "google_organization_iam_custom_role" "custom-org-role" {
  role_id     = var.role_id
  org_id      = var.org_id
  title       = var.role_title
  description = var.role_description
  permissions = var.role_permissions_list
}

# Assign the custom role to a member
resource "google_organization_iam_member" "custom_role_member" {
  org_id = var.org_id
  role   = google_organization_iam_custom_role.custom-org-role.role_id
  member = var.member
}