variable "project_id" {
  description = "The project ID to use for integration tests"
}

variable "credentials_path" {
  description = "Service account credentials for `project_id with permissions to manage service accounts and permissions"
}

variable "shared_vpc_subnets" {
  type = "list"
  default = []
}

provider "google" {
  credentials = "${file(var.credentials_path)}"
}

module "service-accounts" {
  source           = "../../../"
  project_id       = "${var.project_id}"
  credentials_path = "${var.credentials_path}"
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

  shared_vpc_subnets = "${var.shared_vpc_subnets}"
}
