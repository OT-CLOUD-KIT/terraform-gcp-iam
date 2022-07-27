# GCP cloud Storage

[![Opstree Solutions][opstree_avatar]][opstree_homepage]<br/>[Opstree Solutions][opstree_homepage] 

  [opstree_homepage]: https://opstree.github.io/
  [opstree_avatar]: https://img.cloudposse.com/150x150/https://github.com/opstree.png

  - This terraform module will create iam resources and assign bind roles 
  - This project is a part of opstree's ot-gcp initiative for terraform modules.

# Overview of GCP IAM
  IAM lets you grant granular access to specific Google Cloud resources and helps prevent access to other resources. IAM lets you adopt the security principle of least privilege, which states that nobody should have more permissions than they actually need.
  With IAM, you manage access control by defining who (identity) has what access (role) for which resource. For example, Compute Engine virtual machine instances, Google Kubernetes Engine (GKE) clusters, and Cloud Storage buckets are all Google Cloud resources. The organizations, folders, and projects that you use to organize your resources are also resources.
  In IAM, permission to access a resource isn't granted directly to the end user. Instead, permissions are grouped into roles, and roles are granted to authenticated principals. 

## Usage

```
terraform {
  required_providers {
    google = {
      version = "~> 4.19.0"
    }
  }
  required_version = "~>1.1.3"
}

# Configure the GCP Provider

provider "google" {
  credentials = file("<service_account_key_json/p12_file")
  project     = "<project-id>"
  region      = "<region>"
}

# Basic use of this module:
# This will assign a custom role to a user with permissions listed in role_permissions_list[]

module "gcp_iam_custom_project_role" {
  source     = "../../modules/custom_project_role"
  org_id     = "OrgId"
  project_id = "nice-unison-356709"
  role_id = "customRole"
  member     = "user:nilamk.negi@gmail.com"
  role_permissions_list = [
    "storage.objects.create",
    "cloudkms.cryptoKeyVersions.useToEncrypt",
    "compute.instances.create",
    "compute.instances.delete"
  ]
}

# This will assigned a predefinded role to the member user
module "gcp_iam_assign_project_role" {
  source = "../../modules/iam_project"
  role = "roles/compute.networkAdmin"
  project_id = "nice-unison-356709"
  member = "user:nilamk.negi@gmail.com"
}

# This will create a service account and assign a custom role [composed of the set of permissions] to the service account
module "gcp_service_account_custom_role" {
  source     = "../../modules/service-account-custom-role"
  project_id = "nice-unison-356709"
  role_id = "test_service_account_role"
  role_permissions_list = ["compute.disks.create", "compute.firewalls.create", "compute.firewalls.delete", "compute.firewalls.get", "compute.instanceGroupManagers.get", "compute.instances.create", "compute.instances.delete", "compute.instances.get", "compute.instances.setMetadata", "compute.instances.setServiceAccount"]
  role_title = "Test Role"
  role_description = "Custom role for service account"
  account_id = "test-service-account"
  display_name = "Service Account Test creation"
}

# This will create a service account for you and assign a predefined role.
module "gcp_service_account" {
  source     = "../../modules/service-account-role"
  project_id = "nice-unison-356709"
  role_permissions = "roles/editor"
  account_id = "test-service-account-with-role"
  display_name = "Service Account Test creation"
}
```
## Inputs

| Name | Description | Type | Default | Required | Supported |
|------|-------------|:----:|---------|:--------:|:---------:|
|project_id| The ID of the project for which the IAM resource is to be configured | string | | yes| |
|role| An predefined/basic IAM role to be assigned to the member| string | | yes | |
|role_permissions_list| Set of permissions to be assigned to the custom role | list(sring) | |yes| |
|member| Member email id to which the role is to be assigned. This should be in the format user:email or service:email | string | | yes| |
|account_id| Account ID to be used to create the service account| string| | yes | |
|display_name| Display name to be assigned to the service account| string | | yes| |

## Outputs

| Name | Description |
|------|-------------|
|Role| Role ID of the custom role created| string | 
|Permissions| Set of permissions that were assigned to the custom role |
|Project| Project name to which the assigned resource belongs|
|ServiceAccount| Account ID of the service account created|


### Contributors

[![Neelam Negi][neelam_avatar]][neelam_homepage]<br/>[Neelam Negi][neelam_homepage] 

  [neelam_homepage]: https://github.com/neeelamnegi/
  [neelam_avatar]: https://img.cloudposse.com/150x150/https://github.com/neeelamnegi
