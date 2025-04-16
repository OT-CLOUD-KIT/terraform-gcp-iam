## Terraform GCP IAM

[![Opstree Solutions][opstree_avatar]][opstree_homepage]<br/>[Opstree Solutions][opstree_homepage] 

  [opstree_homepage]: https://opstree.github.io/
  [opstree_avatar]: https://img.cloudposse.com/150x150/https://github.com/opstree.png

This Terraform code defines modules to manage Google Cloud IAM (Identity and Access Management). IAM in GCP is used to control who (users) has what access (roles/permissions) to which resources.
Here, we are creating reusable modules to manage IAM roles (predefined and custom) and service accounts along with their role bindings.

## Architecture

<img width="6000" length="8000" alt="Terraform" src="https://github.com/user-attachments/assets/26c523f3-290d-4be9-bc8b-39fbca89478b">


## Providers

| Name                                              | Version  |
|---------------------------------------------------|----------|
| <a name="provider_gcp"></a> [gcp](#provider\_gcp) | 5.0   |

## Usage

```hcl
module "iam_mngmnt" {
  source              = "./modules/iam_mngmnt"
  project_id          = var.project_id
  create_iam_roles    = var.create_iam_roles
  iam_roles           = var.iam_roles
  create_custom_roles = var.create_custom_roles
  custom_roles        = var.custom_roles
}

module "service_account_mngmnt" {
  source           = "./modules/service_account_mngmnt"
  project_id       = var.project_id
  service_accounts = var.service_accounts
  use_custom_roles = var.use_custom_roles
}

# Variable values

region  = "us-central1"
project_id = "nw-opstree-dev-landing-zone"

create_iam_roles = false

iam_roles = {
  "roles/editor" = ["user:xyz@gmail.com"]
  "roles/viewer" = ["user:xyz@gmail.com"]
}

create_custom_roles = false

custom_roles = {
  custom_admin = {
    role_id     = "customAdmin"
    title       = "Custom Admin Role"
    description = "A custom role with admin-like permissions"
    permissions = [
      "iam.roles.get",
      "iam.roles.list",
      "storage.buckets.get"
    ]
    member = "user:xyz@gmail.com"
  }
}

use_custom_roles = false

service_accounts = {
  "sa-billing" = {
    display_name = "Billing Service Account"
    role         = "customAdmin"
  }
  "sa-logging" = {
    display_name = "Logging Service Account"
    role         = "roles/logging.viewer"
  }
}

```

## Inputs

| Name | Description | Type | Default | Required | 
|------|-------------|:----:|---------|:--------:|
|**project_id**| The ID of the project for which the IAM resource is to be configured | string |{ } | yes| 
|**create_iam_roles**| Set to true to create default IAM roles| bool |false | yes | 
|**iam_roles**| Map of default IAM roles and members | map(list(string)) | [ ] |yes| 
|**create_custom_roles**| Map of custom roles with permissions and assignees | bool | false | yes| 
| **custom_roles** | Map of custom roles with permissions and assignees | map(object) | { } | yes|
|**use_custom_roles**| Set to true to assign custom roles to service accounts| bool|false | yes | 
|**service_accounts**| Map of service accounts and their assigned roles| string | { } | yes| 

## Outputs
| Name | Description |
|------|-------------|
|**iam_roles_assigned**| List of default IAM roles assigned| 
|**custom_roles_created**| List of custom IAM roles created |
|**service_accounts_created**| List of service accounts created|
                                                                                                                  
