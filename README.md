# Terraform GCP IAM

[![Opstree Solutions][opstree_avatar]][opstree_homepage]<br/>
[Opstree Solutions][opstree_homepage]

[opstree_homepage]: https://opstree.github.io/
[opstree_avatar]: https://img.cloudposse.com/150x150/https://github.com/opstree.png

Reusable Terraform module for additive Google Cloud project IAM, custom roles, service accounts, temporary access, and Privileged Access Manager entitlements.

## Features

- Additive project IAM role assignments without taking ownership of the entire project policy
- Dedicated Google and Cloud Identity group bindings
- Expiry-based IAM Conditions using RFC3339 timestamps
- Generic additive IAM Conditions for resource, request, and access-level expressions
- Project custom roles with multiple member assignments
- Service-account creation with multiple project roles per account
- Privileged Access Manager entitlements with optional approval workflows
- PAM requester justification, approver, role, condition, and notification configuration
- Input validation and migration-friendly map keys

## Usage

```hcl
module "iam" {
  source = "../../"

  project_id = var.project_id

  project_bindings = {
    log_viewers = {
      role    = "roles/logging.viewer"
      members = ["user:platform-user@example.com"]
    }
  }

  group_bindings = {
    platform_viewers = {
      role   = "roles/viewer"
      groups = ["platform@example.com"]
    }
  }

  expiring_bindings = {
    temporary_operator = {
      role       = "roles/compute.instanceAdmin.v1"
      members    = ["user:contractor@example.com"]
      expires_at = "2027-01-31T18:30:00Z"
    }
  }

  conditional_bindings = {
    production_instances = {
      role        = "roles/compute.viewer"
      members     = ["group:platform@example.com"]
      title       = "production-instances-only"
      description = "Restrict access to production Compute Engine instances."
      expression  = "resource.name.startsWith(\"projects/${var.project_id}/zones/us-central1-a/instances/prod-\")"
    }
  }

  custom_roles = {
    storage_object_operator = {
      role_id     = "storageObjectOperator"
      title       = "Storage Object Operator"
      description = "Limited access to view and manage storage objects."
      permissions = [
        "storage.objects.get",
        "storage.objects.list",
        "storage.objects.create"
      ]
      members = ["group:storage-operators@example.com"]
    }
  }

  service_accounts = {
    application-runtime = {
      display_name = "Application runtime"
      roles = [
        "roles/logging.logWriter",
        "roles/monitoring.metricWriter"
      ]
    }
  }

  pam_entitlements = {
    project_operator = {
      entitlement_id       = "project-operator-access"
      max_request_duration = "3600s"
      eligible_principals  = ["group:platform-engineers@example.com"]
      role_bindings = [
        {
          role = "roles/compute.instanceAdmin.v1"
        }
      ]
      approval = {
        approvals_needed    = 1
        approver_principals = ["group:platform-approvers@example.com"]
      }
    }
  }
}
```

## IAM binding behavior

This module uses `google_project_iam_member`, which is additive. It manages only the configured principal-role pairs and does not replace every member assigned to a role.

An expiry-based binding generates the following IAM condition:

```text
request.time < timestamp("2027-01-31T18:30:00Z")
```

Do not grant the same principal and role unconditionally elsewhere. An unconditional binding makes a time-based binding ineffective.

## Privileged Access Manager

PAM entitlements provide on-demand, time-bound privilege elevation. An entitlement can grant predefined or custom roles, require justification, require approval, and send additional notifications.

Before creating PAM entitlements:

1. Enable `privilegedaccessmanager.googleapis.com`.
2. Grant the Terraform identity the required PAM and resource-level IAM administration permissions.
3. Use a supported project, folder, or organization parent and matching resource URI.

When `parent` and `resource` are omitted, the module targets `project_id`.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `project_id` | Project for project-level IAM resources | `string` | n/a | yes |
| `project_bindings` | Additive role assignments for arbitrary principals | `map(object)` | `{}` | no |
| `group_bindings` | Additive project roles for groups | `map(object)` | `{}` | no |
| `expiring_bindings` | IAM bindings with an RFC3339 expiry timestamp | `map(object)` | `{}` | no |
| `conditional_bindings` | IAM bindings with caller-supplied IAM Conditions expressions | `map(object)` | `{}` | no |
| `custom_roles` | Project custom roles and member assignments | `map(object)` | `{}` | no |
| `service_accounts` | Managed service accounts and their project roles | `map(object)` | `{}` | no |
| `pam_entitlements` | PAM entitlement definitions | `map(object)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `project_binding_ids` | IDs of additive project bindings |
| `group_binding_ids` | IDs of group bindings |
| `expiring_binding_ids` | IDs of temporary IAM bindings |
| `conditional_binding_ids` | IDs of generic conditional IAM bindings |
| `custom_role_names` | Fully qualified custom-role names |
| `service_account_emails` | Emails of service accounts created by the module |
| `pam_entitlement_names` | Fully qualified PAM entitlement names |

## Security considerations

- Prefer groups over direct user assignments for standing access.
- Use expiring bindings or PAM for temporary privileged access.
- Avoid basic Owner and Editor roles where narrower predefined or custom roles are available.
- Review custom-role permissions for least privilege.
- Do not create service-account keys in this module; prefer Workload Identity Federation or service-account impersonation.
- Store Terraform state in a protected remote backend because IAM state contains security-sensitive metadata.

## Design decisions

- IAM member assignments are additive by default, matching the safe mode used by mature registry modules.
- Authoritative bindings are intentionally excluded because they can remove members managed outside this module.
- This module manages project IAM. Resource-specific IAM for buckets, KMS keys, Pub/Sub, Secret Manager, and similar services should remain in focused resource modules.

## Upgrade from the previous module

| Capability | Previous module | Updated module |
|------------|-----------------|----------------|
| Predefined project roles | Role-to-member map | Stable additive binding maps |
| Group access | Group had to be entered as a generic member | Dedicated group bindings with automatic `group:` normalization |
| Temporary access | Not supported | RFC3339 expiry-based IAM Conditions |
| Other IAM Conditions | Not supported | Caller-supplied conditional expressions |
| Custom roles | One member per custom role | Multiple members per custom role |
| Service accounts | One role per account | Multiple roles per account |
| PAM entitlements | Not supported | Time-bound access with optional justification, approval, and notifications |
| Validation | Minimal | Expiry, entitlement ID, role stage, approval, and required-member validation |
| Terraform/provider | Terraform 1.1 and Google provider 4.x example | Terraform 1.6+ and Google provider 7.x |
| Authentication example | Local credential-file pattern | Uses normal provider authentication configured by the caller |
| Outputs | Resource-key lists | Binding IDs, custom-role names, service-account emails, and PAM entitlement names |

The updated module uses a single root-module interface instead of separate nested IAM and service-account modules. Existing Terraform state should be reviewed and migrated or imported before applying the updated module to resources already managed by the previous implementation.

## License

Apache 2.0. See [LICENSE](LICENSE).
