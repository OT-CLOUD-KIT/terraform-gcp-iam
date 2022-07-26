# Assign an existing role to a project

resource "google_project_iam_member" "project_iam" {
  project = var.project_id
  role    = var.role
  member  = var.member
}