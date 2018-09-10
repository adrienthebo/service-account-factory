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

/* An example module using the project factory and network module to manage multiple
 * service accounts, with some having network access.
 */

variable "organization_id" {}
variable "billing_account" {}
variable "credentials_path" {}

provider "google" {
  credentials = "${file(var.credentials_path)}"
}

module "project-factory" {
  source           = "github.com/terraform-google-modules/terraform-google-project-factory"
  name             = "simple"
  org_id           = "${var.organization_id}"
  billing_account  = "${var.billing_account}"
  credentials_path = "${var.credentials_path}"
}

module "vpc" {
    source = "github.com/terraform-google-modules/terraform-google-network"
    project_id   = "${module.project-factory.project_id}"
    network_name = "example-vpc"

    subnets = [
        {
            subnet_name           = "subnet-01"
            subnet_ip             = "10.10.10.0/24"
            subnet_region         = "us-west1"
            subnet_private_access = false
        },
        {
            subnet_name           = "subnet-02"
            subnet_ip             = "10.10.20.0/24"
            subnet_region         = "us-west1"
            subnet_private_access = false
        },
    ]

    secondary_ranges = {
        subnet-01 = [
            {
                range_name    = "subnet-01-secondary-01"
                ip_cidr_range = "192.168.64.0/24"
            },
        ]

        subnet-02 = []
    }
}

module "service-accounts" {
  source           = "../../"
  project_id       = "${module.project-factory.project_id}"
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
  shared_vpc_subnets = [
    "projects/${module.project-factory.project_id}/regions/us-west1/subnetworks/subnet-01",
    "projects/${module.project-factory.project_id}/regions/us-west1/subnetworks/subnet-02",
  ]
}
