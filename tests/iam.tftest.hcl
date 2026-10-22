mock_provider "google" {}

run "project_group_custom_role_and_service_account" {
  command = plan

  variables {
    project_id = "example-project"

    project_bindings = {
      log_viewers = {
        role    = "roles/logging.viewer"
        members = ["user:viewer@example.com"]
      }
    }

    group_bindings = {
      platform_viewers = {
        role   = "roles/viewer"
        groups = ["platform@example.com"]
      }
    }

    custom_roles = {
      limited_storage = {
        role_id     = "limitedStorage"
        title       = "Limited Storage"
        permissions = ["storage.objects.get"]
        members     = ["group:storage@example.com"]
      }
    }

    service_accounts = {
      application-runtime = {
        roles = [
          "roles/logging.logWriter",
          "roles/monitoring.metricWriter"
        ]
      }
    }
  }

  assert {
    condition     = length(google_project_iam_member.project) == 1
    error_message = "One additive project IAM member binding must be created."
  }

  assert {
    condition     = values(google_project_iam_member.group)[0].member == "group:platform@example.com"
    error_message = "Group email must be normalized to an IAM group principal."
  }

  assert {
    condition     = length(google_project_iam_member.service_account) == 2
    error_message = "Both service-account roles must be assigned."
  }
}

run "expiring_access" {
  command = plan

  variables {
    project_id = "example-project"

    expiring_bindings = {
      temporary_operator = {
        role       = "roles/compute.instanceAdmin.v1"
        members    = ["user:contractor@example.com"]
        expires_at = "2027-01-31T18:30:00Z"
      }
    }
  }

  assert {
    condition     = values(google_project_iam_member.expiring)[0].condition[0].expression == "request.time < timestamp(\"2027-01-31T18:30:00Z\")"
    error_message = "The temporary IAM condition must enforce the configured expiry timestamp."
  }
}

run "generic_conditional_access" {
  command = plan

  variables {
    project_id = "example-project"

    conditional_bindings = {
      production_only = {
        role       = "roles/compute.viewer"
        members    = ["group:platform@example.com"]
        title      = "production-only"
        expression = "resource.name.startsWith(\"projects/example-project/zones/us-central1-a/instances/prod-\")"
      }
    }
  }

  assert {
    condition     = length(google_project_iam_member.conditional) == 1
    error_message = "One generic conditional IAM member binding must be created."
  }
}

run "pam_entitlement_with_approval" {
  command = plan

  variables {
    project_id = "example-project"

    pam_entitlements = {
      operator = {
        entitlement_id      = "project-operator-access"
        eligible_principals = ["group:engineers@example.com"]
        role_bindings = [
          {
            role = "roles/compute.instanceAdmin.v1"
          }
        ]
        approval = {
          approvals_needed    = 1
          approver_principals = ["group:approvers@example.com"]
        }
      }
    }
  }

  assert {
    condition     = google_privileged_access_manager_entitlement.this["operator"].max_request_duration == "3600s"
    error_message = "PAM entitlement must use the secure one-hour default duration."
  }
}

run "reject_invalid_expiry" {
  command = plan

  variables {
    project_id = "example-project"

    expiring_bindings = {
      invalid = {
        role       = "roles/viewer"
        members    = ["user:viewer@example.com"]
        expires_at = "not-a-timestamp"
      }
    }
  }

  expect_failures = [var.expiring_bindings]
}

run "reject_invalid_pam_justification" {
  command = plan

  variables {
    project_id = "example-project"

    pam_entitlements = {
      invalid = {
        entitlement_id          = "invalid-entitlement"
        eligible_principals     = ["group:engineers@example.com"]
        requester_justification = "FREE_TEXT"
        role_bindings = [
          {
            role = "roles/logging.viewer"
          }
        ]
      }
    }
  }

  expect_failures = [var.pam_entitlements]
}
