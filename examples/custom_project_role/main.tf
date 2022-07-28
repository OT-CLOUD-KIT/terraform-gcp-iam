provider "google" {
  credentials = file("credentials.json")
  project     = "nice-unison-356709"
  region      = "us-central1"
}

module "gcp_iam_custom_project_role" {
  source     = "../../modules/custom_project_role"
  project_id = "nice-unison-356709"
  role_id    = "customRole"
  member     = "user:nilamk.negi@gmail.com"
  role_permissions_list = [
    "storage.objects.create",
    "cloudkms.cryptoKeyVersions.useToEncrypt",
    "compute.instances.create",
    "compute.instances.delete"
  ]
}