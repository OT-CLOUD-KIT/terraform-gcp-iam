provider "google" {
  credentials = file("testadmin.json")
  project     = "nice-unison-356709"
  region      = "us-central1"
}

module "gcp_iam_assign_project_role" {
  source     = "../../modules/iam_project"
  role       = "roles/compute.networkAdmin"
  project_id = "nice-unison-356709"
  member     = "user:nilamk.negi@gmail.com"
}