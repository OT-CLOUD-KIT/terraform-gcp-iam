provider "google" {
  credentials = file("credentials.json")
  project     = "nice-unison-356709"
  region      = "us-central1"
}

module "gcp_service_account_custom_role" {
  source                = "../../modules/service-account-custom-role"
  project_id            = "nice-unison-356709"
  role_id               = "test_service_account_role"
  role_permissions_list = ["compute.disks.create", "compute.firewalls.create", "compute.firewalls.delete", "compute.firewalls.get", "compute.instanceGroupManagers.get", "compute.instances.create", "compute.instances.delete", "compute.instances.get", "compute.instances.setMetadata", "compute.instances.setServiceAccount", "compute.instances.setTags", "compute.machineTypes.get", "compute.networks.create", "compute.networks.delete", "compute.networks.get", "compute.networks.updatePolicy", "compute.subnetworks.create", "compute.subnetworks.delete", "compute.subnetworks.get", "compute.subnetworks.setPrivateIpGoogleAccess", "compute.subnetworks.update", "compute.subnetworks.use", "compute.subnetworks.useExternalIp", "compute.zones.get", "container.clusters.create", "container.clusters.delete", "container.clusters.get", "container.clusters.update", "container.operations.get"]
  role_title            = "Test Role"
  role_description      = "Custom role for service account"
  account_id            = "test-service-account"
  display_name          = "Service Account Test creation"
}