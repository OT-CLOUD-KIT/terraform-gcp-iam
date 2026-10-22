provider "google" {
  project = var.project_id
}

module "iam" {
  source = "../../"

  project_id = var.project_id

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
      expires_at = var.temporary_access_expiry
    }
  }

  custom_roles = {
    storage_reader = {
      role_id     = "limitedStorageReader"
      title       = "Limited Storage Reader"
      description = "Reads bucket and object metadata."
      permissions = [
        "storage.buckets.get",
        "storage.objects.get",
        "storage.objects.list"
      ]
      members = ["group:platform@example.com"]
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
}
