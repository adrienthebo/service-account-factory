provider "google" {
  credentials = "${file(var.credentials_path)}"
}

module "service-accounts" {
  source = "../../../"
  project_id = "${var.project_id}"
  service_accounts = [
    {
      account_id     = "editor-service-account"
      description    = "Service account with editor rights"
      roles          = ["roles/editor"]
      network_access = true
    },
    {
      account_id     = "browser-service-account"
      description    = "Service account with browser rights"
      roles          = ["roles/browser"]
      network_access = false
    },
    {
      account_id     = "limited-service-account"
      description    = "Service account with no special rights"
      roles          = []
    },
  ]
}
