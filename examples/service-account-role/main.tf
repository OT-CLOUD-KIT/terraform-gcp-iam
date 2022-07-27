provider "google" {
  credentials = file("credentials.json")
  project     = "nice-unison-356709"
  region      = "us-central1"
}

module "gcp_service_account" {
  source     = "../../modules/service-account-role"
  project_id = "nice-unison-356709"
  role_permissions = "roles/editor"
  account_id = "test-service-account-with-role"
  display_name = "Service Account Test creation"
}