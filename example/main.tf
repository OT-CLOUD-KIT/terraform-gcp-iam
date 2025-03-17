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


