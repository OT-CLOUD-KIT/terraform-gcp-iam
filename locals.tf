locals {
  project_binding_members = merge({}, [
    for binding_key, binding in var.project_bindings : {
      for member in binding.members : "${binding_key}/${sha1(member)}" => {
        role   = binding.role
        member = member
      }
    }
  ]...)

  group_binding_members = merge({}, [
    for binding_key, binding in var.group_bindings : {
      for group in binding.groups : "${binding_key}/${sha1(group)}" => {
        role   = binding.role
        member = startswith(group, "group:") ? group : "group:${group}"
      }
    }
  ]...)

  expiring_binding_members = merge({}, [
    for binding_key, binding in var.expiring_bindings : {
      for member in binding.members : "${binding_key}/${sha1(member)}" => {
        role        = binding.role
        member      = member
        title       = coalesce(binding.title, "expires-${binding_key}")
        description = coalesce(binding.description, "Temporary access expires at ${binding.expires_at}.")
        expression  = "request.time < timestamp(\"${binding.expires_at}\")"
      }
    }
  ]...)

  conditional_binding_members = merge({}, [
    for binding_key, binding in var.conditional_bindings : {
      for member in binding.members : "${binding_key}/${sha1(member)}" => {
        role        = binding.role
        member      = member
        title       = binding.title
        description = binding.description
        expression  = binding.expression
      }
    }
  ]...)

  custom_role_members = merge({}, [
    for role_key, role in var.custom_roles : {
      for member in role.members : "${role_key}/${sha1(member)}" => {
        role_key = role_key
        member   = member
      }
    }
  ]...)

  service_account_roles = merge({}, [
    for account_key, account in var.service_accounts : {
      for role in account.roles : "${account_key}/${sha1(role)}" => {
        account_key = account_key
        role        = role
      }
    }
  ]...)
}
