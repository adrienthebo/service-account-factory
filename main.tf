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

resource "google_service_account" "project_service_accounts" {
  count = "${length(var.service_accounts)}"

  account_id   = "${lookup(var.service_accounts[count.index], "account_id")}"
  display_name = "${lookup(var.service_accounts[count.index], "description")}"
  project      = "${var.project_id}"
}
