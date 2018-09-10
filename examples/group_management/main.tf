/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/* A simple example creating a few service accounts in a project created by
 * the project-factory module.
 */

variable "organization_id" {}
variable "billing_account" {}
variable "credentials_path" {}
variable "impersonated_user_email" {}

provider "google" {
  credentials = "${file(var.credentials_path)}"
}

data "google_organization" "org" {
  organization = "${var.organization_id}"
}

module "project-factory" {
  source           = "github.com/terraform-google-modules/terraform-google-project-factory"
  name             = "simple"
  org_id           = "${var.organization_id}"
  billing_account  = "${var.billing_account}"
  credentials_path = "${var.credentials_path}"
}

module "service-accounts" {
  source                  = "../../"
  project_id              = "${module.project-factory.project_id}"
  credentials_path        = "${var.credentials_path}"
  impersonated_user_email = "${var.impersonated_user_email}"
  service_accounts = [
    {
      account_id     = "editor-service-account"
      description    = "Service account with editor rights"
      groups         = ["service-accounts@${data.google_organization.org.domain}"]
    },
    {
      account_id     = "browser-service-account"
      description    = "Service account with browser rights"
    },
  ]
}
