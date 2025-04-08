region = "us-central1"

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

use_custom_roles = false # Assign custom roles to service accounts

service_accounts = {
  "sa-billing" = {
    display_name = "Billing Service Account"
    role         = "customAdmin" # Custom IAM role
  }
  "sa-logging" = {
    display_name = "Logging Service Account"
    role         = "roles/logging.viewer" # Default IAM role
  }
}