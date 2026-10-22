resource "google_project_iam_member" "project" {
  for_each = local.project_binding_members

  project = var.project_id
  role    = each.value.role
  member  = each.value.member
}

resource "google_project_iam_member" "group" {
  for_each = local.group_binding_members

  project = var.project_id
  role    = each.value.role
  member  = each.value.member
}

resource "google_project_iam_member" "expiring" {
  for_each = local.expiring_binding_members

  project = var.project_id
  role    = each.value.role
  member  = each.value.member

  condition {
    title       = each.value.title
    description = each.value.description
    expression  = each.value.expression
  }
}

resource "google_project_iam_member" "conditional" {
  for_each = local.conditional_binding_members

  project = var.project_id
  role    = each.value.role
  member  = each.value.member

  condition {
    title       = each.value.title
    description = each.value.description
    expression  = each.value.expression
  }
}

resource "google_project_iam_custom_role" "custom" {
  for_each = var.custom_roles

  project     = var.project_id
  role_id     = each.value.role_id
  title       = each.value.title
  description = each.value.description
  permissions = each.value.permissions
  stage       = each.value.stage
}

resource "google_project_iam_member" "custom" {
  for_each = local.custom_role_members

  project = var.project_id
  role    = google_project_iam_custom_role.custom[each.value.role_key].name
  member  = each.value.member
}

resource "google_service_account" "managed" {
  for_each = var.service_accounts

  project      = var.project_id
  account_id   = each.key
  display_name = coalesce(each.value.display_name, each.key)
  description  = each.value.description
  disabled     = each.value.disabled
}

resource "google_project_iam_member" "service_account" {
  for_each = local.service_account_roles

  project = var.project_id
  role    = each.value.role
  member  = "serviceAccount:${google_service_account.managed[each.value.account_key].email}"
}

resource "google_privileged_access_manager_entitlement" "this" {
  for_each = var.pam_entitlements

  parent               = coalesce(each.value.parent, "projects/${var.project_id}")
  location             = each.value.location
  entitlement_id       = each.value.entitlement_id
  max_request_duration = each.value.max_request_duration

  eligible_users {
    principals = each.value.eligible_principals
  }

  requester_justification_config {
    dynamic "unstructured" {
      for_each = each.value.requester_justification == "UNSTRUCTURED" ? [1] : []
      content {}
    }

    dynamic "not_mandatory" {
      for_each = each.value.requester_justification == "NOT_MANDATORY" ? [1] : []
      content {}
    }
  }

  privileged_access {
    gcp_iam_access {
      resource_type = each.value.resource_type
      resource      = coalesce(each.value.resource, "//cloudresourcemanager.googleapis.com/projects/${var.project_id}")

      dynamic "role_bindings" {
        for_each = each.value.role_bindings
        content {
          role                 = role_bindings.value.role
          condition_expression = role_bindings.value.condition_expression
        }
      }
    }
  }

  approval_workflow {
    manual_approvals {
      require_approver_justification = each.value.approval == null ? false : each.value.approval.require_approver_justification

      dynamic "steps" {
        for_each = each.value.approval == null ? [] : [each.value.approval]
        content {
          approvals_needed          = steps.value.approvals_needed
          approver_email_recipients = steps.value.approver_email_recipients

          approvers {
            principals = steps.value.approver_principals
          }
        }
      }
    }
  }

  additional_notification_targets {
    admin_email_recipients     = each.value.additional_notification_targets.admin_email_recipients
    requester_email_recipients = each.value.additional_notification_targets.requester_email_recipients
  }
}
