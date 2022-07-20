output "project" {
  value = module.gcp_iam_assign_project_role.project
  description = "Details of the project that was assigned role"
}