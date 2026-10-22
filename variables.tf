variable "project_id" {
  description = "Google Cloud project ID in which project-level IAM resources are managed."
  type        = string

  validation {
    condition     = length(trimspace(var.project_id)) > 0
    error_message = "project_id must not be empty."
  }
}

variable "project_bindings" {
  description = "Additive project IAM bindings for users, groups, service accounts, domains, or federated principals."
  type = map(object({
    role    = string
    members = set(string)
  }))
  default = {}

  validation {
    condition     = alltrue([for binding in values(var.project_bindings) : length(binding.members) > 0])
    error_message = "Every project binding must contain at least one member."
  }
}

variable "group_bindings" {
  description = "Additive project IAM bindings dedicated to Google or Cloud Identity groups. Group emails may be supplied with or without the group: prefix."
  type = map(object({
    role   = string
    groups = set(string)
  }))
  default = {}

  validation {
    condition     = alltrue([for binding in values(var.group_bindings) : length(binding.groups) > 0])
    error_message = "Every group binding must contain at least one group."
  }
}

variable "expiring_bindings" {
  description = "Temporary additive project IAM bindings. expires_at must be an RFC3339 timestamp."
  type = map(object({
    role        = string
    members     = set(string)
    expires_at  = string
    title       = optional(string)
    description = optional(string)
  }))
  default = {}

  validation {
    condition = alltrue([
      for binding in values(var.expiring_bindings) :
      length(binding.members) > 0 && can(timecmp(binding.expires_at, binding.expires_at))
    ])
    error_message = "Every expiring binding needs at least one member and a valid RFC3339 expires_at timestamp."
  }
}

variable "conditional_bindings" {
  description = "Additive project IAM bindings controlled by a caller-supplied IAM Conditions expression."
  type = map(object({
    role        = string
    members     = set(string)
    title       = string
    description = optional(string)
    expression  = string
  }))
  default = {}

  validation {
    condition = alltrue([
      for binding in values(var.conditional_bindings) :
      length(binding.members) > 0 &&
      length(trimspace(binding.title)) > 0 &&
      length(trimspace(binding.expression)) > 0
    ])
    error_message = "Every conditional binding needs members, a title, and a non-empty IAM Conditions expression."
  }
}

variable "custom_roles" {
  description = "Project custom roles and optional additive member assignments."
  type = map(object({
    role_id     = string
    title       = string
    description = optional(string)
    permissions = set(string)
    stage       = optional(string, "GA")
    members     = optional(set(string), [])
  }))
  default = {}

  validation {
    condition     = alltrue([for role in values(var.custom_roles) : length(role.permissions) > 0])
    error_message = "Every custom role must contain at least one permission."
  }

  validation {
    condition = alltrue([
      for role in values(var.custom_roles) :
      contains(["ALPHA", "BETA", "GA", "DEPRECATED", "DISABLED", "EAP"], role.stage)
    ])
    error_message = "Custom role stage must be ALPHA, BETA, GA, DEPRECATED, DISABLED, or EAP."
  }
}

variable "service_accounts" {
  description = "Service accounts created by this module with zero or more additive project role assignments."
  type = map(object({
    display_name = optional(string)
    description  = optional(string)
    disabled     = optional(bool, false)
    roles        = optional(set(string), [])
  }))
  default = {}
}

variable "pam_entitlements" {
  description = "Privileged Access Manager entitlements for temporary, optionally approval-based privilege elevation."
  type = map(object({
    entitlement_id          = string
    parent                  = optional(string)
    location                = optional(string, "global")
    max_request_duration    = optional(string, "3600s")
    eligible_principals     = set(string)
    requester_justification = optional(string, "UNSTRUCTURED")
    resource_type           = optional(string, "cloudresourcemanager.googleapis.com/Project")
    resource                = optional(string)
    role_bindings = list(object({
      role                 = string
      condition_expression = optional(string)
    }))
    approval = optional(object({
      require_approver_justification = optional(bool, true)
      approvals_needed               = optional(number, 1)
      approver_principals            = set(string)
      approver_email_recipients      = optional(set(string), [])
    }))
    additional_notification_targets = optional(object({
      admin_email_recipients     = optional(set(string), [])
      requester_email_recipients = optional(set(string), [])
    }), {})
  }))
  default = {}

  validation {
    condition = alltrue([
      for entitlement in values(var.pam_entitlements) :
      can(regex("^[a-z][a-z0-9-]{2,61}[a-z0-9]$", entitlement.entitlement_id))
    ])
    error_message = "PAM entitlement IDs must be 4-63 characters, start with a lowercase letter, and contain only lowercase letters, numbers, and hyphens."
  }

  validation {
    condition = alltrue([
      for entitlement in values(var.pam_entitlements) :
      length(entitlement.eligible_principals) > 0 && length(entitlement.role_bindings) > 0
    ])
    error_message = "Every PAM entitlement needs at least one eligible principal and one role binding."
  }

  validation {
    condition = alltrue([
      for entitlement in values(var.pam_entitlements) :
      contains(["UNSTRUCTURED", "NOT_MANDATORY"], entitlement.requester_justification)
    ])
    error_message = "requester_justification must be UNSTRUCTURED or NOT_MANDATORY."
  }

  validation {
    condition = alltrue([
      for entitlement in values(var.pam_entitlements) :
      entitlement.approval == null || (
        entitlement.approval.approvals_needed >= 1 &&
        length(entitlement.approval.approver_principals) > 0
      )
    ])
    error_message = "Approval-based PAM entitlements need at least one approval and one approver principal."
  }
}
