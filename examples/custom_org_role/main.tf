provider "google" {
  credentials = file("credentials.json")
  project     = var.project_id
  region      = var.region
}

module "gcp_iam_custom_org_role" {
  source = "../../modules/custom_org_role"
  role_permissions_list = [
    "storage.objects.create",
    "cloudkms.cryptoKeyVersions.useToEncrypt",
    "compute.instances.create",
    "compute.instances.delete"
  ]
  #   permissions = var.role_permissions_list
}