variable "project_id" {
  type    = string
  default = "nice-unison-356709"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "role_id" {
  type    = string
  default = "my_service_infra_admin"
}

variable "role_permissions_list" {
  type    = list(string)
  default = ["compute.disks.create", "compute.firewalls.create", "compute.firewalls.delete", "compute.firewalls.get", "compute.instanceGroupManagers.get", "compute.instances.create", "compute.instances.delete", "compute.instances.get", "compute.instances.setMetadata", "compute.instances.setServiceAccount", "compute.instances.setTags", "compute.machineTypes.get", "compute.networks.create", "compute.networks.delete", "compute.networks.get", "compute.networks.updatePolicy", "compute.subnetworks.create", "compute.subnetworks.delete", "compute.subnetworks.get", "compute.subnetworks.setPrivateIpGoogleAccess", "compute.subnetworks.update", "compute.subnetworks.use", "compute.subnetworks.useExternalIp", "compute.zones.get", "container.clusters.create", "container.clusters.delete", "container.clusters.get", "container.clusters.update", "container.operations.get"]
}

variable "member" {
  type    = list(string)
  default = ["serviceAccount:testadmin@nice-unison-356709.iam.gserviceaccount.com"]
}