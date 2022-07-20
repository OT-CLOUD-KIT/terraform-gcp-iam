# Create a custom iam role at project level

resource "google_project_iam_custom_role" "custom-project-role" {
  role_id     = var.role_id
  title       = var.role_title
  description = var.role_description
  # permissions = [
  #   "storage.objects.create", 
  #   "cloudkms.cryptoKeyVersions.useToEncrypt",
  #   "compute.instances.create",
  #   "compute.instances.delete"
  # ]
  permissions = var.role_permissions_list
}

# Assign the custom role to member
resource "google_project_iam_member" "custom_role_member" {
  project = var.project_id
  role   = google_project_iam_custom_role.custom-project-role.id
  member = var.member
}